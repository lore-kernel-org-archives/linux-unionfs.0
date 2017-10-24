Return-Path: <cgxu@mykernel.net>
From: cgxu <cgxu@mykernel.net>
Message-Id: <13AD7BBD-8CE9-4BCA-A0B4-4CAA7FD75F72@mykernel.net>
Content-Type: multipart/alternative;
 boundary="Apple-Mail=_590ED07C-1BB0-4E9C-B536-4A8DEF574240"
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] long mount option support
Date: Tue, 24 Oct 2017 18:25:43 +0800
In-Reply-To: <CAJfpeguPKtGMZ_YYyBqDc=WOvwK6fSiFMJW4NdESR5X+w3tLoA@mail.gmail.com>
References: <D90A2B0B-C311-4F73-9CB7-D6361EDCD131@mykernel.net>
 <CAJfpeguPKtGMZ_YYyBqDc=WOvwK6fSiFMJW4NdESR5X+w3tLoA@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>


--Apple-Mail=_590ED07C-1BB0-4E9C-B536-4A8DEF574240
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=gb2312

Thanks for your prompt response. I=A1=AFm also looking forward to see =
the implementation. :-)


Best Regards,
cgxu


> =D4=DA 2017=C4=EA10=D4=C224=C8=D5=A3=AC=CF=C2=CE=E75:43=A3=ACMiklos =
Szeredi <miklos@szeredi.hu> =D0=B4=B5=C0=A3=BA
>=20
> On Tue, Oct 24, 2017 at 5:44 AM, cgxu <cgxu@mykernel.net> wrote:
>> Hi Miklos,
>>=20
>> We=A1=AFre testing our container system using overlayfs as image =
storage.
>> We noticed that although overlayfs supports maximum 500 layers in =
filesystem,
>> but  when lowerdir is quite long then mount will fail because of =
mount option=A1=AFs one PAGE SIZE limitation.
>> In our environment, we added new mount option =A1=B0long_option=A1=B1 =
to deliver long mount option with extended attribute.
>> This approach is backward compatible and could be useful to =
container.
>> I have done basic testing on this and hope to hear some feedback for =
the patch.
>>=20
>> Detail explanations:
>> In this approach, we can set mount option both in command line and =
config file=A1=AFs extended attribute.
>> There are three possible cases as below.
>=20
> Patchset from David Howells (*) will allow unlimited mount options.
> I'd rather wait for that than adding hacks to work around the page
> size limitation.
>=20
> Thanks,
> Miklos
>=20
> (*) =
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1506283.html
>=20


--Apple-Mail=_590ED07C-1BB0-4E9C-B536-4A8DEF574240
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=gb2312

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dgb2312"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D"">Thanks for your prompt response. I=A1=AFm also looking =
forward to see the implementation. :-)<div class=3D""><div class=3D"">
<div style=3D"color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; orphans: auto; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: =
auto; word-spacing: 0px; -webkit-text-size-adjust: auto; =
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
word-spacing: 0px; -webkit-text-stroke-width: 0px;"><br =
class=3D"Apple-interchange-newline"><br class=3D""></div><div =
style=3D"color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px;">Best Regards,</div><div style=3D"color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px;" =
class=3D"">cgxu</div></div></div></div><br =
class=3D"Apple-interchange-newline">
</div>
<br class=3D""><div><blockquote type=3D"cite" class=3D""><div =
class=3D"">=D4=DA 2017=C4=EA10=D4=C224=C8=D5=A3=AC=CF=C2=CE=E75:43=A3=ACMi=
klos Szeredi &lt;<a href=3D"mailto:miklos@szeredi.hu" =
class=3D"">miklos@szeredi.hu</a>&gt; =D0=B4=B5=C0=A3=BA</div><br =
class=3D"Apple-interchange-newline"><div class=3D""><div class=3D"">On =
Tue, Oct 24, 2017 at 5:44 AM, cgxu &lt;<a =
href=3D"mailto:cgxu@mykernel.net" class=3D"">cgxu@mykernel.net</a>&gt; =
wrote:<br class=3D""><blockquote type=3D"cite" class=3D"">Hi Miklos,<br =
class=3D""><br class=3D"">We=A1=AFre testing our container system using =
overlayfs as image storage.<br class=3D"">We noticed that although =
overlayfs supports maximum 500 layers in filesystem,<br class=3D"">but =
&nbsp;when lowerdir is quite long then mount will fail because of mount =
option=A1=AFs one PAGE SIZE limitation.<br class=3D"">In our =
environment, we added new mount option =A1=B0long_option=A1=B1 to =
deliver long mount option with extended attribute.<br class=3D"">This =
approach is backward compatible and could be useful to container.<br =
class=3D"">I have done basic testing on this and hope to hear some =
feedback for the patch.<br class=3D""><br class=3D"">Detail =
explanations:<br class=3D"">In this approach, we can set mount option =
both in command line and config file=A1=AFs extended attribute.<br =
class=3D"">There are three possible cases as below.<br =
class=3D""></blockquote><br class=3D"">Patchset from David Howells (*) =
will allow unlimited mount options.<br class=3D"">I'd rather wait for =
that than adding hacks to work around the page<br class=3D"">size =
limitation.<br class=3D""><br class=3D"">Thanks,<br class=3D"">Miklos<br =
class=3D""><br class=3D"">(*) <a =
href=3D"https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg15062=
83.html" =
class=3D"">https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg15=
06283.html</a><br class=3D""><br =
class=3D""></div></div></blockquote></div><br =
class=3D""></div></body></html>=

--Apple-Mail=_590ED07C-1BB0-4E9C-B536-4A8DEF574240--
