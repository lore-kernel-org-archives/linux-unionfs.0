Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH v5] ovl: Check link ability between upperdir and workdir
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAJfpegsDRMutL39Viep8yvVSYUxdGdrJpe9b2yUstTkt_p5Ygw@mail.gmail.com>
Date: Sun, 1 Apr 2018 13:56:42 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <B7E9E89A-DFFD-4E87-987F-591856C26EAC@gmx.com>
References: <1516464659-130410-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxge28c0TmCbP+pS_nxQD1CpygEHUNZLAtdQjNHzd9KpyQ@mail.gmail.com>
 <CAJfpegsDRMutL39Viep8yvVSYUxdGdrJpe9b2yUstTkt_p5Ygw@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, Amir Goldstein <amir73il@gmail.com>, Chengguang Xu <cgxu519@icloud.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA3=D4=C229=C8=D5=A3=AC=CF=C2=CE=E78:54=A3=ACMiklos =
Szeredi <miklos@szeredi.hu> =D0=B4=B5=C0=A3=BA
>=20
> On Sat, Jan 20, 2018 at 7:32 PM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>> On Sat, Jan 20, 2018 at 6:10 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>> Inspired by encountering unexpected write error with
>>> error code -EXDEV when upperdir and workdir having
>>> different project quotas. The reason of the error is
>>> project quota asks files in it strictly inherit
>>> project id of it=A1=AFs own, so rename/link operations
>>> between those directories will fail and it may cause
>>> failure during copy-up/index-link operations in overlayfs.
>>>=20
>>> So if upper filesystem supports O_TMPFILE, try to check
>>> link ability between upperdir and workdir and if check
>>> fails, print a proper warning message to indicate potential
>>> possibility of write failure.
>>>=20
>>> The failure of the check does not directly lead to
>>> read-only mounting because in some use cases may only
>>> write to upperdir and do not modify anything in lowerdirs.
>=20
> Thinking about a bit more: this assumes that mounter has create
> permission under upper layer root.  That assumption would be true in
> ordinary setups.  But if we break that assumption and deny create in
> the root of the upper layer, we could still have a perfectly working
> setup (as long as there's no need to copy-up anything in that
> directory).

Isn=A1=AFt it similar to the check which upperdir and workdir must be in =
same filesystem?
If we set project quota then the related directories will behave like =
sub-filesystem.


Thanks,
Chengguang.


>=20
> So I'm not sure it's worth adding code for a check that is of dubious =
value.
>=20
> Thanks,
> Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
