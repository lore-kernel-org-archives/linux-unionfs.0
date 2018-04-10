Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: [PATCH v5] ovl: Check link ability between upperdir and workdir
From: cgxu519@gmx.com
In-Reply-To: <CAJfpegu+o2JmDsi-S_ggm=Nyg73j7mxe8016+UAovR-NZi9YuQ@mail.gmail.com>
Date: Tue, 10 Apr 2018 08:50:38 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <A22365BA-D5FA-404A-9595-C4399EFD237F@gmx.com>
References: <1516464659-130410-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxge28c0TmCbP+pS_nxQD1CpygEHUNZLAtdQjNHzd9KpyQ@mail.gmail.com>
 <CAJfpegsDRMutL39Viep8yvVSYUxdGdrJpe9b2yUstTkt_p5Ygw@mail.gmail.com>
 <B7E9E89A-DFFD-4E87-987F-591856C26EAC@gmx.com>
 <CAJfpegu+o2JmDsi-S_ggm=Nyg73j7mxe8016+UAovR-NZi9YuQ@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA4=D4=C24=C8=D5=A3=AC=CF=C2=CE=E75:30=A3=ACMiklos =
Szeredi <miklos@szeredi.hu> =D0=B4=B5=C0=A3=BA
>=20
> On Sun, Apr 1, 2018 at 7:56 AM, cgxu519@gmx.com <cgxu519@gmx.com> =
wrote:
>> =D4=DA 2018=C4=EA3=D4=C229=C8=D5=A3=AC=CF=C2=CE=E78:54=A3=ACMiklos =
Szeredi <miklos@szeredi.hu> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Sat, Jan 20, 2018 at 7:32 PM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>>>> On Sat, Jan 20, 2018 at 6:10 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>>> Inspired by encountering unexpected write error with
>>>>> error code -EXDEV when upperdir and workdir having
>>>>> different project quotas. The reason of the error is
>>>>> project quota asks files in it strictly inherit
>>>>> project id of it=A1=AFs own, so rename/link operations
>>>>> between those directories will fail and it may cause
>>>>> failure during copy-up/index-link operations in overlayfs.
>>>>>=20
>>>>> So if upper filesystem supports O_TMPFILE, try to check
>>>>> link ability between upperdir and workdir and if check
>>>>> fails, print a proper warning message to indicate potential
>>>>> possibility of write failure.
>>>>>=20
>>>>> The failure of the check does not directly lead to
>>>>> read-only mounting because in some use cases may only
>>>>> write to upperdir and do not modify anything in lowerdirs.
>>>=20
>>> Thinking about a bit more: this assumes that mounter has create
>>> permission under upper layer root.  That assumption would be true in
>>> ordinary setups.  But if we break that assumption and deny create in
>>> the root of the upper layer, we could still have a perfectly working
>>> setup (as long as there's no need to copy-up anything in that
>>> directory).
>>=20
>> Isn=A1=AFt it similar to the check which upperdir and workdir must be =
in same filesystem?
>> If we set project quota then the related directories will behave like =
sub-filesystem.
>=20
>=20
> I agree with that.
>=20
> What I'm saying is that your implementation may give a false positive
> (i.e. warning on an otherwise perfectly working setup).
>=20
> Worse yet, it may change the result of the tmpfile test in such a
> case, which is a regression.
>=20
> So I think the implementation needs to be rethought.

So maybe back to compare project ids is better? If we want to accurately =
recognize
the condition we also need to check inherit flag in inode and that check =
depends on
underlying filesystems, we can build supporting infrastructure for that =
but I=A1=AFm not
sure if it is worth.



Thanks,
Chengguang.
