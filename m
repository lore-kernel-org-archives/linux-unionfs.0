MIME-Version: 1.0
In-Reply-To: <CAOQ4uxge28c0TmCbP+pS_nxQD1CpygEHUNZLAtdQjNHzd9KpyQ@mail.gmail.com>
References: <1516464659-130410-1-git-send-email-cgxu519@icloud.com>
	<CAOQ4uxge28c0TmCbP+pS_nxQD1CpygEHUNZLAtdQjNHzd9KpyQ@mail.gmail.com>
Date: Thu, 29 Mar 2018 14:54:54 +0200
Message-ID: <CAJfpegsDRMutL39Viep8yvVSYUxdGdrJpe9b2yUstTkt_p5Ygw@mail.gmail.com>
Subject: Re: [PATCH v5] ovl: Check link ability between upperdir and workdir
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chengguang Xu <cgxu519@icloud.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Jan 20, 2018 at 7:32 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Sat, Jan 20, 2018 at 6:10 PM, Chengguang Xu <cgxu519@icloud.com> wrote=
:
>> Inspired by encountering unexpected write error with
>> error code -EXDEV when upperdir and workdir having
>> different project quotas. The reason of the error is
>> project quota asks files in it strictly inherit
>> project id of it=E2=80=99s own, so rename/link operations
>> between those directories will fail and it may cause
>> failure during copy-up/index-link operations in overlayfs.
>>
>> So if upper filesystem supports O_TMPFILE, try to check
>> link ability between upperdir and workdir and if check
>> fails, print a proper warning message to indicate potential
>> possibility of write failure.
>>
>> The failure of the check does not directly lead to
>> read-only mounting because in some use cases may only
>> write to upperdir and do not modify anything in lowerdirs.

Thinking about a bit more: this assumes that mounter has create
permission under upper layer root.  That assumption would be true in
ordinary setups.  But if we break that assumption and deny create in
the root of the upper layer, we could still have a perfectly working
setup (as long as there's no need to copy-up anything in that
directory).

So I'm not sure it's worth adding code for a check that is of dubious value=
.

Thanks,
Miklos
