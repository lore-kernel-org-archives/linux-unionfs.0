Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <0A20195D-8A68-4955-AAE2-992A926B7333@gmx.com>
References: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
 <1522558675-70756-2-git-send-email-cgxu519@gmx.com> <CAOQ4uxhyT5V4+8OBgDk3aVHcXtmvN62ZYiHppoAGMbNNCSmDYw@mail.gmail.com>
 <8935A82A-6C2B-46B8-9E88-D1FD987C4542@gmx.com> <CAOQ4uxioPwtEBZyYps-hnyAXoH_zVr2pdP-Rkc4Xb_ZMicw16w@mail.gmail.com>
 <C2127448-4F45-43F9-AF2E-2CF51BC980A4@gmx.com> <CAOQ4uxhc9ceXeS-WJYc8MPh73ipVUxEO7iK5uCVikfrpq2bG7A@mail.gmail.com>
 <5FEFAF00-D681-4FD2-AF4A-CDEB8A2B3CC6@gmx.com> <CAOQ4uxhQ6exzwNTzTo01Tby7pk0ONWgqZyHOBnB31Yr5vPtPjg@mail.gmail.com>
 <0A20195D-8A68-4955-AAE2-992A926B7333@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 2 Apr 2018 16:09:35 +0300
Message-ID: <CAOQ4uxh7TCiNp1PYu-GfJAQwgVMrHPGScGX6b1yz4nOxrt1=7A@mail.gmail.com>
Subject: Re: [PATCH 2/2] ovl: return error when specifying unchangeable
 options in remount
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "cgxu519@gmx.com" <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 2, 2018 at 3:32 PM, cgxu519@gmx.com <cgxu519@gmx.com> wrote:
[...]

>> What you gain is shorter and more generic code to print the error:
>> "overlayfs: option %s cannot be changed on remount"
>> AND
>> "overlayfs: option %s cannot be added on remount=E2=80=9D
>
> I=E2=80=99m wondering how we deal with the case which is specifying same =
option
> several times in a remount. More specifically current lowerdir=3Daaa and
> specify options -o remount,lowerdir=3Dbbb,lowerdir=3Daaa,ro then if we fa=
il
> at first different value, it seems we will break compatibility with mount
> in parsing options.
>

I don't think we should care. if user does that on purpose user
should get an error.
only if user does something sane, like mount -o remount,lowerdir=3Dbbb
and mount command reorders that in a weird way we may need to handle
this case.

Thanks,
Amir.
