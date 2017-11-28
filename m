Return-Path: <cgxu@mykernel.net>
From: Chengguang Xu <cgxu@mykernel.net>
Message-Id: <6CF216FF-424A-4737-9C32-0857331A7762@mykernel.net>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_11229A34-9B43-42A4-94FC-4599CA8EAD6A"
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] ovl: Sync upper dirty data when sync overlayfs
Date: Tue, 28 Nov 2017 20:49:01 +0800
In-Reply-To: <CAOQ4uxhKSaUamDfyX49o41jH6v6751X8XxYegEmS=g7roGHM8Q@mail.gmail.com>
References: <1511844026-12765-1-git-send-email-cgxu@mykernel.net>
 <CAOQ4uxiL8vdkcTSGnqGKtH1AVaZ+W0LcaTaoi6mifGjhq48Ljg@mail.gmail.com>
 <0DEF5E95-D6C6-4F2C-9710-C4DC8BB14691@mykernel.net>
 <CAOQ4uxgbM_bFkm_hymvn6U2i+NZQG2LAqpH8XtTsduVLJXdHDQ@mail.gmail.com>
 <50026B1F-55D2-4352-8EAB-9DDA32F9BB4D@mykernel.net>
 <CAOQ4uxhKSaUamDfyX49o41jH6v6751X8XxYegEmS=g7roGHM8Q@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>


--Apple-Mail=_11229A34-9B43-42A4-94FC-4599CA8EAD6A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=gb2312


Hi Amir,

I=A1=AFve sent new version of patch for review.

Thanks for giving me advice for many things. It=A1=AFs really helpful to =
newbie.



> =D4=DA 2017=C4=EA11=D4=C228=C8=D5=A3=AC=CF=C2=CE=E77:00=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Tue, Nov 28, 2017 at 11:27 AM, cgxu <cgxu@mykernel.net =
<mailto:cgxu@mykernel.net>> wrote:
>>=20
>>> =D4=DA 2017=C4=EA11=D4=C228=C8=D5=A3=AC=CF=C2=CE=E75:00=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Tue, Nov 28, 2017 at 10:18 AM, cgxu <cgxu@mykernel.net> wrote:
>>>>=20
>>> [...]
>>>>> Unless I am missing something subtle here, you should export vfs
>>>>> __sync_filesystem and call it from here instead of duplicating it.
>>>>> Any technical reason not to do it?
>>>>>=20
>>>>=20
>>>> Actually, not a technical reason. How about below modification?
>>>> If it looks good I=A1=AFll send patch on new mail thread.
>>>>=20
>>>=20
>>> Much better. See one nit below.
>>> Why new mail thread? It is better if you send V3 patch with same =
subject
>>> and change log since V2, so maintainer knows this patch supersedes
>>> the previous one.
>>>=20
>>=20
>> Thank you, got it.
>> BTW, currently I use mainline tree, should I rebase on overlay-next? =
or other tree?
>>=20
>=20
> Current overlay-next is merged to master and your patch makes very
> little changes
> outside fs/overlayfs so the answer is it doesn't matter.
> Usually you should rebase on overlay-next when posting a patch to =
overlayfs
> maintainer.
>=20
> Cheers,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org =
<mailto:majordomo@vger.kernel.org>
> More majordomo info at  http://vger.kernel.org/majordomo-info.html =
<http://vger.kernel.org/majordomo-info.html>

--Apple-Mail=_11229A34-9B43-42A4-94FC-4599CA8EAD6A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=gb2312

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dgb2312"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;" class=3D""><br =
class=3D""><div class=3D"">
<div style=3D"color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div style=3D"color: rgb(0, 0, 0); letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space;" class=3D""><div style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div style=3D"color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;">Hi Amir,</div><div =
style=3D"color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px;"><br class=3D""></div><div style=3D"color:=
 rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: =
0px;">I=A1=AFve sent new version of patch for review.</div><div =
style=3D"color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px;"><br class=3D""></div><div style=3D"color:=
 rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: =
0px;">Thanks for giving me advice for many things. It=A1=AFs really =
helpful to newbie.</div></div></div></div><br =
class=3D"Apple-interchange-newline" style=3D"color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px;"><br =
class=3D"Apple-interchange-newline">
</div>
<div><br class=3D""><blockquote type=3D"cite" class=3D""><div =
class=3D"">=D4=DA 2017=C4=EA11=D4=C228=C8=D5=A3=AC=CF=C2=CE=E77:00=A3=ACAm=
ir Goldstein &lt;<a href=3D"mailto:amir73il@gmail.com" =
class=3D"">amir73il@gmail.com</a>&gt; =D0=B4=B5=C0=A3=BA</div><br =
class=3D"Apple-interchange-newline"><div class=3D""><span =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
float: none; display: inline !important;" class=3D"">On Tue, Nov 28, =
2017 at 11:27 AM, cgxu &lt;</span><a href=3D"mailto:cgxu@mykernel.net" =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px;" =
class=3D"">cgxu@mykernel.net</a><span style=3D"font-family: =
Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; float: none; display: =
inline !important;" class=3D"">&gt; wrote:</span><br style=3D"font-family:=
 Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D""><blockquote=
 type=3D"cite" style=3D"font-family: Menlo-Regular; font-size: 11px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px;" class=3D""><br class=3D""><blockquote =
type=3D"cite" class=3D"">=D4=DA 2017=C4=EA11=D4=C228=C8=D5=A3=AC=CF=C2=CE=E7=
5:00=A3=ACAmir Goldstein &lt;<a href=3D"mailto:amir73il@gmail.com" =
class=3D"">amir73il@gmail.com</a>&gt; =D0=B4=B5=C0=A3=BA<br class=3D""><br=
 class=3D"">On Tue, Nov 28, 2017 at 10:18 AM, cgxu &lt;<a =
href=3D"mailto:cgxu@mykernel.net" class=3D"">cgxu@mykernel.net</a>&gt; =
wrote:<br class=3D""><blockquote type=3D"cite" class=3D""><br =
class=3D""></blockquote>[...]<br class=3D""><blockquote type=3D"cite" =
class=3D""><blockquote type=3D"cite" class=3D"">Unless I am missing =
something subtle here, you should export vfs<br =
class=3D"">__sync_filesystem and call it from here instead of =
duplicating it.<br class=3D"">Any technical reason not to do it?<br =
class=3D""><br class=3D""></blockquote><br class=3D"">Actually, not a =
technical reason. How about below modification?<br class=3D"">If it =
looks good I=A1=AFll send patch on new mail thread.<br class=3D""><br =
class=3D""></blockquote><br class=3D"">Much better. See one nit =
below.<br class=3D"">Why new mail thread? It is better if you send V3 =
patch with same subject<br class=3D"">and change log since V2, so =
maintainer knows this patch supersedes<br class=3D"">the previous =
one.<br class=3D""><br class=3D""></blockquote><br class=3D"">Thank you, =
got it.<br class=3D"">BTW, currently I use mainline tree, should I =
rebase on overlay-next? or other tree?<br class=3D""><br =
class=3D""></blockquote><br style=3D"font-family: Menlo-Regular; =
font-size: 11px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D""><span =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
float: none; display: inline !important;" class=3D"">Current =
overlay-next is merged to master and your patch makes very</span><br =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px;" =
class=3D""><span style=3D"font-family: Menlo-Regular; font-size: 11px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; float: none; display: inline =
!important;" class=3D"">little changes</span><br style=3D"font-family: =
Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D""><span =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
float: none; display: inline !important;" class=3D"">outside =
fs/overlayfs so the answer is it doesn't matter.</span><br =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px;" =
class=3D""><span style=3D"font-family: Menlo-Regular; font-size: 11px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; float: none; display: inline =
!important;" class=3D"">Usually you should rebase on overlay-next when =
posting a patch to overlayfs</span><br style=3D"font-family: =
Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D""><span =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
float: none; display: inline !important;" class=3D"">maintainer.</span><br=
 style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px;" =
class=3D""><br style=3D"font-family: Menlo-Regular; font-size: 11px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px;" class=3D""><span style=3D"font-family: =
Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; float: none; display: =
inline !important;" class=3D"">Cheers,</span><br style=3D"font-family: =
Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D""><span =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
float: none; display: inline !important;" class=3D"">Amir.</span><br =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px;" =
class=3D""><span style=3D"font-family: Menlo-Regular; font-size: 11px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; float: none; display: inline =
!important;" class=3D"">--</span><br style=3D"font-family: =
Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D""><span =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
float: none; display: inline !important;" class=3D"">To unsubscribe from =
this list: send the line "unsubscribe linux-unionfs" in</span><br =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px;" =
class=3D""><span style=3D"font-family: Menlo-Regular; font-size: 11px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; float: none; display: inline =
!important;" class=3D"">the body of a message to<span =
class=3D"Apple-converted-space">&nbsp;</span></span><a =
href=3D"mailto:majordomo@vger.kernel.org" style=3D"font-family: =
Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px;" =
class=3D"">majordomo@vger.kernel.org</a><br style=3D"font-family: =
Menlo-Regular; font-size: 11px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D""><span =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
float: none; display: inline !important;" class=3D"">More majordomo info =
at &nbsp;</span><a href=3D"http://vger.kernel.org/majordomo-info.html" =
style=3D"font-family: Menlo-Regular; font-size: 11px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px;" =
class=3D"">http://vger.kernel.org/majordomo-info.html</a></div></blockquot=
e></div><br class=3D""></body></html>=

--Apple-Mail=_11229A34-9B43-42A4-94FC-4599CA8EAD6A--
