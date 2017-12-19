From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3] ovl: Check link ability between upperdir and workdir
Date: Tue, 19 Dec 2017 16:11:13 +0200
Message-ID: <CAOQ4uxi-wpRdUv20uaSrE=R_kYWcb8jmOUu-Xp+XeA-AA0-eWA@mail.gmail.com>
References: <1513601748-57439-1-git-send-email-cgxu519@icloud.com>
 <20171218160251.GA7474@redhat.com> <C6350633-4F41-424F-B936-606CDAF2A8DF@icloud.com>
 <20171219134849.GA2737@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f173.google.com ([209.85.213.173]:34187 "EHLO
        mail-yb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751084AbdLSOLP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Dec 2017 09:11:15 -0500
Received: by mail-yb0-f173.google.com with SMTP id z11so13696965ybm.1
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Dec 2017 06:11:15 -0800 (PST)
In-Reply-To: <20171219134849.GA2737@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Chengguang Xu <cgxu519@icloud.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Dec 19, 2017 at 3:48 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Dec 19, 2017 at 09:49:28AM +0800, Chengguang Xu wrote:
>> >
>> > =E5=9C=A8 2017=E5=B9=B412=E6=9C=8819=E6=97=A5=EF=BC=8C=E4=B8=8A=E5=8D=
=8812:02=EF=BC=8CVivek Goyal <vgoyal@redhat.com> =E5=86=99=E9=81=93=EF=BC=
=9A
>> >
>> > On Mon, Dec 18, 2017 at 08:55:48PM +0800, Chengguang Xu wrote:
>> >> Inspired by encountering unexpected write error when
>> >> upperdir and workdir having different project ids.
>> >
>> > Can you please make this problem descrition little better. By
>> > these two lines I really don't understand what's the problem
>> > you are trying to solve. All I understood was that upperdir
>> > and workdir had different project id. But not sure what
>> > problem it led to and why.
>> >
>> > In fact your first patch changelong was little better. It
>> > atleast said that you encounter "-EXDEV". So is it rename
>> > which fails. So rename is not allowed between two directories
>> > having different project ids?
>> >
>>
>> The background is
>> I encountered an unexpected write error with error code -EXDEV in
>> my environment which didn=E2=80=99t break any rules in overlayfs kernel
>> document.
>>
>> So I did some investigations and found when upperdir and workdir
>> having different project quotas then rename/link operations between
>> those directories would be fail with -EXDEV because project quota
>> asks files in it strictly inherit project id with it=E2=80=99s own. This=
 will
>> make write fail during copy-up process.
>>
>> I wrote first patch to check this condition, but that check seems not
>> sufficient to detect write error, so after discussion with Amir,
>> we decided to check link ability between upperdir and workdir, it is
>> what copy-up actually doing when modifying files in lowerdirs, and also
>> I decided to only print a warning message instead of directly mounting
>> on read-only mode in case there is a special use case just read and do n=
ot
>> modify anything in lowerdirs.
>
> Ok, thanks for the explanation. I really wish that some of it makes to
> changelog so that somebody reading it later finds it much easier to
> understand.
>
> BTW, just curious, when upper supports O_TMPFILE, do we have to create
> tmpfile in workdir/. Can we create it in upper/ and then link in
> appropriate destination directory.
>

Do you mean like this:
d8514d8edb5b ovl: copy up regular file using O_TMPFILE

> Amir, is there a fundamental requirement about why tmpfile creation has
> to be in workdir.
>

It isn't. With indexed copy up, tmpfile is created in indexdir and linked t=
o
index dir, then linked again to upper dir.
With non-indexed copy up (of regular file, when O_TMPFILE supported)
tmpfile is created in upperdir and linked to upper dir, which allows for
concurrent copy up of two files within different parent dirs.

Amir.
