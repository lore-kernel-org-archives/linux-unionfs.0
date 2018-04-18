Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: [PATCH 2/3] ovl: using lowestack handling functions to replace
 bare array operation
From: cgxu519@gmx.com
In-Reply-To: <CAOQ4uxjdjZYUw_6Y6AqWpR+Rb_9iinsTxKzm39yjpWpiwhLvOQ@mail.gmail.com>
Date: Wed, 18 Apr 2018 11:42:42 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <761957C2-F131-4F4D-A08C-0AB2614A32D3@gmx.com>
References: <1523932965-25792-1-git-send-email-cgxu519@gmx.com>
 <1523932965-25792-2-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxjdjZYUw_6Y6AqWpR+Rb_9iinsTxKzm39yjpWpiwhLvOQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>


> =D4=DA 2018=C4=EA4=D4=C217=C8=D5=A3=AC=CF=C2=CE=E77:16=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Tue, Apr 17, 2018 at 5:42 AM, Chengguang Xu <cgxu519@gmx.com> =
wrote:
>> ovl_*_lower() can handle lowerstack requirement well and more =
importantly
>> we can hide detail lowerstack implementation for outside. so using =
these
>> functions to replace bare array operaion.
>>=20
>=20
> In not using bare array operation a worthy goal??
> If you follow my suggestion in patch 3/3, you will be able to avoid =
this goal
> and keep using array operations instead of __ovl_path_lower().

In this patch series, hiding detail operation of array is necessary,
your suggestion makes the modification shorter and simpler but maybe
lose a bit of flexibility when trying to change lowerstack layers.=20
However, we don=A1=AFt have to worry about that too much on this stage.
I=A1=AFll repost modified patch.

Thanks,
Chengguang.=
