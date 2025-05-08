from enum import IntFlag

import comtypes.gen._00020430_0000_0000_C000_000000000046_0_2_0 as __wrapper_module__
from comtypes.gen._00020430_0000_0000_C000_000000000046_0_2_0 import (
    StdFont, OLE_YSIZE_HIMETRIC, Color, Gray, EXCEPINFO, GUID,
    IPictureDisp, BSTR, OLE_YPOS_PIXELS, DISPPROPERTY, FONTNAME,
    Picture, FONTSTRIKETHROUGH, OLE_ENABLEDEFAULTBOOL, DISPPARAMS,
    FONTUNDERSCORE, _lcid, VgaColor, OLE_YPOS_HIMETRIC,
    OLE_CANCELBOOL, OLE_YSIZE_PIXELS, OLE_YPOS_CONTAINER,
    IFontEventsDisp, Default, CoClass, Unchecked, OLE_HANDLE,
    FONTSIZE, OLE_YSIZE_CONTAINER, typelib_path, IUnknown, FontEvents,
    OLE_XSIZE_PIXELS, OLE_COLOR, Checked, FONTITALIC, StdPicture,
    OLE_OPTEXCLUSIVE, dispid, Font, FONTBOLD, Monochrome,
    _check_version, HRESULT, IFontDisp, Library, OLE_XSIZE_CONTAINER,
    COMMETHOD, OLE_XPOS_PIXELS, IPicture, IEnumVARIANT, VARIANT_BOOL,
    OLE_XPOS_HIMETRIC, OLE_XPOS_CONTAINER, IDispatch,
    OLE_XSIZE_HIMETRIC, DISPMETHOD, IFont
)


class LoadPictureConstants(IntFlag):
    Default = 0
    Monochrome = 1
    VgaColor = 2
    Color = 4


class OLE_TRISTATE(IntFlag):
    Unchecked = 0
    Checked = 1
    Gray = 2


__all__ = [
    'StdFont', 'OLE_XSIZE_PIXELS', 'OLE_YSIZE_HIMETRIC', 'OLE_COLOR',
    'Checked', 'OLE_TRISTATE', 'FONTITALIC', 'StdPicture',
    'OLE_OPTEXCLUSIVE', 'Font', 'FONTBOLD', 'Color', 'Monochrome',
    'Gray', 'IPictureDisp', 'OLE_YPOS_PIXELS', 'IFontDisp', 'Library',
    'FONTNAME', 'Picture', 'FONTSTRIKETHROUGH', 'OLE_XSIZE_CONTAINER',
    'LoadPictureConstants', 'OLE_ENABLEDEFAULTBOOL',
    'OLE_XPOS_PIXELS', 'FONTUNDERSCORE', 'IPicture', 'VgaColor',
    'OLE_XPOS_HIMETRIC', 'OLE_YPOS_HIMETRIC', 'OLE_XPOS_CONTAINER',
    'OLE_YSIZE_PIXELS', 'OLE_CANCELBOOL', 'OLE_YPOS_CONTAINER',
    'IFontEventsDisp', 'Default', 'Unchecked', 'OLE_XSIZE_HIMETRIC',
    'OLE_HANDLE', 'FONTSIZE', 'OLE_YSIZE_CONTAINER', 'typelib_path',
    'FontEvents', 'IFont'
]

