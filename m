Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: [PATCH v4 0/3] option validation in remount
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAOQ4uxhRuU5okDMCLxE4kxB0zTQfY_K9_DCvOnAVXm676yE_Jg@mail.gmail.com>
Date: Sat, 14 Apr 2018 14:00:31 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <3C7F0A49-39C5-456F-BC18-3AFF5D9936AC@gmx.com>
References: <1523623156-6035-1-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxhRuU5okDMCLxE4kxB0zTQfY_K9_DCvOnAVXm676yE_Jg@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA4=D4=C213=C8=D5=A3=AC=CF=C2=CE=E78:56=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Fri, Apr 13, 2018 at 3:39 PM, Chengguang Xu <cgxu519@gmx.com> =
wrote:
>> Some overlayfs mount options cannot be changed via remount,
>> but current remount does not return error even if we specify
>> different value to unchangeable options.
>>=20
>> This patch series adjust option parsing to support remount
>> and return proper error message and code when recogonizing
>> unchangeable options in remount.
>>=20
>=20
> Surely, you have motivation beyond what is listed here.
> Would be nice to list short and long term goals for changing
> remount options.
>=20
> The series looks ok to me.
> There is a question whether erroring on remount with changed
> options is considered a regression to some applications.
> I don't know how to answer that.
> Does your use case *require* that remount will fail?
> Would it be ok to ignore unchangeable options like today,
> but warn about it?

hmmm, some of our sysadmins get confused by the phenomenon of
success remount without changing options. It=A1=AFs obviously different
compare to other filesystems but I think with proper explanation
they can accept this and change their scripts.


>=20
> After Miklos approves the expected behavior,
> please write xfstests to verify expected behavior.

Sure, I=A1=AFll make a case to verify it.
