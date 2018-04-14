Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: [PATCH v4 0/3] option validation in remount
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAJfpegvXh0CQu-YrfcOqHP7W7geRzVokTanA0Dgm-qi2vm1=qQ@mail.gmail.com>
Date: Sat, 14 Apr 2018 13:49:18 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <8C8670DA-D8A2-4684-9CAD-ABAE4C0FDE99@gmx.com>
References: <1523623156-6035-1-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxhRuU5okDMCLxE4kxB0zTQfY_K9_DCvOnAVXm676yE_Jg@mail.gmail.com>
 <CAJfpegvXh0CQu-YrfcOqHP7W7geRzVokTanA0Dgm-qi2vm1=qQ@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>


> =D4=DA 2018=C4=EA4=D4=C213=C8=D5=A3=AC=CF=C2=CE=E79:46=A3=ACMiklos =
Szeredi <miklos@szeredi.hu> =D0=B4=B5=C0=A3=BA
>=20
> On Fri, Apr 13, 2018 at 2:56 PM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>> On Fri, Apr 13, 2018 at 3:39 PM, Chengguang Xu <cgxu519@gmx.com> =
wrote:
>>> Some overlayfs mount options cannot be changed via remount,
>>> but current remount does not return error even if we specify
>>> different value to unchangeable options.
>>>=20
>>> This patch series adjust option parsing to support remount
>>> and return proper error message and code when recogonizing
>>> unchangeable options in remount.
>>>=20
>>=20
>> Surely, you have motivation beyond what is listed here.
>> Would be nice to list short and long term goals for changing
>> remount options.
>>=20
>> The series looks ok to me.
>> There is a question whether erroring on remount with changed
>> options is considered a regression to some applications.
>=20
> Theoretically: yes.  In real life: maybe.  We need to be careful.
>=20
>> I don't know how to answer that.
>> Does your use case *require* that remount will fail?
>> Would it be ok to ignore unchangeable options like today,
>> but warn about it?
>=20
> Adding a warning is definitely okay, since it makes no sense to supply
> unchangeable options.  Maybe at some point we can change the warning
> to a failure.
>=20
> It would have been best to error out on unknown/unchangeable options
> from the start.  Hopefully the new mount API will make implementing
> option parsing and reconfiguration less error prone.

I=A1=AFll modify the code to only print warning but not return error =
code
when user trying to change unchangeable options, but if user specifies
unrecognized option or the option is invalid then still return -EINVAL.

Thanks,
Chengguang.
