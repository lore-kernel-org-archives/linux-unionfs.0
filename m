MIME-Version: 1.0
In-Reply-To: <B7E9E89A-DFFD-4E87-987F-591856C26EAC@gmx.com>
References: <1516464659-130410-1-git-send-email-cgxu519@icloud.com>
	<CAOQ4uxge28c0TmCbP+pS_nxQD1CpygEHUNZLAtdQjNHzd9KpyQ@mail.gmail.com>
	<CAJfpegsDRMutL39Viep8yvVSYUxdGdrJpe9b2yUstTkt_p5Ygw@mail.gmail.com>
	<B7E9E89A-DFFD-4E87-987F-591856C26EAC@gmx.com>
Date: Wed, 4 Apr 2018 11:30:38 +0200
Message-ID: <CAJfpegu+o2JmDsi-S_ggm=Nyg73j7mxe8016+UAovR-NZi9YuQ@mail.gmail.com>
Subject: Re: [PATCH v5] ovl: Check link ability between upperdir and workdir
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "cgxu519@gmx.com" <cgxu519@gmx.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Chengguang Xu <cgxu519@icloud.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Apr 1, 2018 at 7:56 AM, cgxu519@gmx.com <cgxu519@gmx.com> wrote:
> =E5=9C=A8 2018=E5=B9=B43=E6=9C=8829=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=888:=
54=EF=BC=8CMiklos Szeredi <miklos@szeredi.hu> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Sat, Jan 20, 2018 at 7:32 PM, Amir Goldstein <amir73il@gmail.com> wro=
te:
>>> On Sat, Jan 20, 2018 at 6:10 PM, Chengguang Xu <cgxu519@icloud.com> wro=
te:
>>>> Inspired by encountering unexpected write error with
>>>> error code -EXDEV when upperdir and workdir having
>>>> different project quotas. The reason of the error is
>>>> project quota asks files in it strictly inherit
>>>> project id of it=E2=80=99s own, so rename/link operations
>>>> between those directories will fail and it may cause
>>>> failure during copy-up/index-link operations in overlayfs.
>>>>
>>>> So if upper filesystem supports O_TMPFILE, try to check
>>>> link ability between upperdir and workdir and if check
>>>> fails, print a proper warning message to indicate potential
>>>> possibility of write failure.
>>>>
>>>> The failure of the check does not directly lead to
>>>> read-only mounting because in some use cases may only
>>>> write to upperdir and do not modify anything in lowerdirs.
>>
>> Thinking about a bit more: this assumes that mounter has create
>> permission under upper layer root.  That assumption would be true in
>> ordinary setups.  But if we break that assumption and deny create in
>> the root of the upper layer, we could still have a perfectly working
>> setup (as long as there's no need to copy-up anything in that
>> directory).
>
> Isn=E2=80=99t it similar to the check which upperdir and workdir must be =
in same filesystem?
> If we set project quota then the related directories will behave like sub=
-filesystem.


I agree with that.

What I'm saying is that your implementation may give a false positive
(i.e. warning on an otherwise perfectly working setup).

Worse yet, it may change the result of the tmpfile test in such a
case, which is a regression.

So I think the implementation needs to be rethought.

Thanks,
Miklos


>
>
> Thanks,
> Chengguang.
>
>
>>
>> So I'm not sure it's worth adding code for a check that is of dubious va=
lue.
>>
>> Thanks,
>> Miklos
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-unionfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
