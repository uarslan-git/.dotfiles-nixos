{-# OPTIONS_GHC -Wno-deprecations #-}
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.ToggleLayouts
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.IndependentScreens
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run
import Graphics.X11.Xlib
import Graphics.X11.Xinerama
import Graphics.X11.Xrandr
import System.Process (callCommand)
import XMonad.Layout.ThreeColumns

main :: IO ()
main = do
    n <- countScreens
    xmprocs <- mapM (\i -> spawnPipe $ "xmobar /home/user/.xmobarrc" ++ " -x " ++ show i) [0..n-1]

    xmonad $ ewmhFullscreen . ewmh $  xmobarProp $ def
        { modMask            = mod4Mask
        , terminal           = "alacritty"
        , borderWidth        = 1
		, focusFollowsMouse  = True
        , normalBorderColor  = "#282c34"
		, handleEventHook    = fullscreenEventHook
        , focusedBorderColor = "#61afef"
        , startupHook        = myStartupHook >> setWMName "LG3D"
        , layoutHook         = myLayout
        } `additionalKeysP` myKeys

myStartupHook = do
    spawnOnce "keepassxc"
    spawnOnce "flameshot"
    spawnOnce "nm-applet"
    spawnOnce "copyq"
    spawn "feh --bg-fill ~/.config/bg.jpg"
    spawn "picom"

myLayout = toggleLayouts  Full $ spacing 8 $ Tall 1 (3/100) (1/2)

myManageHook = composeAll
    [ className =? "Firefox" --> doShift "2"
    , className =? "Gimp" --> doFloat
    , isFullscreen --> doFloat
    ]

myKeys =
    [ ("M-S-<Return>", spawn "alacritty")
    , ("M-d", spawn "rofi -show drun -show-icons")
    , ("M-S-p", spawn "thunar")
    , ("M-S-o", spawn "keepassxc")
    , ("M-S-;", spawn "copyq show")
    , ("M-S-i", spawn "pavucontrol")
    , ("M-S-s", spawn "flameshot gui")
    , ("M-S-l", spawn "lock")
    , ("M-S-c", kill)  -- Close focused window
    , ("M-b", sendMessage ToggleStruts)
    , ("M-f", sendMessage (Toggle "Full"))
    , ("M-q", spawn "xmonad --recompile; pkill xmobar; xmonad --restart")
    ]
