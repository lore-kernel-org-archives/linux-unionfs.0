From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3] ovl: Check link ability between upperdir and workdir
Date: Tue, 19 Dec 2017 20:32:05 +0200
Message-ID: <CAOQ4uxiTB4xiypzVBzFnWB+NRj-Siu6wmLGyqCxFGF_+KLmTLA@mail.gmail.com>
References: <1513601748-57439-1-git-send-email-cgxu519@icloud.com>
 <20171218160251.GA7474@redhat.com> <C6350633-4F41-424F-B936-606CDAF2A8DF@icloud.com>
 <20171219134849.GA2737@redhat.com> <CAOQ4uxi-wpRdUv20uaSrE=R_kYWcb8jmOUu-Xp+XeA-AA0-eWA@mail.gmail.com>
 <20171219154242.GA6043@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:38579 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdLSScG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Dec 2017 13:32:06 -0500
Received: by mail-yb0-f182.google.com with SMTP id 129so5134681ybe.5
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Dec 2017 10:32:06 -0800 (PST)
In-Reply-To: <20171219154242.GA6043@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Chengguang Xu <cgxu519@icloud.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Dec 19, 2017 at 5:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Dec 19, 2017 at 04:11:13PM +0200, Amir Goldstein wrote:
> [..]
>> With non-indexed copy up (of regular file, when O_TMPFILE supported)
>> tmpfile is created in upperdir and linked to upper dir, which allows for
>> concurrent copy up of two files within different parent dirs.
>
> Is it correct. I am looking at the code and we always seem to get tmpfile
> in work/work.
>
> ovl_copy_up_locked()
>   ovl_get_tmpfile()
>       ovl_do_tmpfile(c->workdir, c->stat.mode)
>
> I was hoping that for a regular file copy up, we could create tmpfile in
> upper/ so that we don't have the requirement of allowing linking between
> work/ and upper/ as long as upper supported tmpfile. But given that index
> will require linking with alias in upper, we can't get rid of this
> requirement completely.
>

Ah, I see. I guess there is just no strong reason to change that, because
still have the rename requirement for non-regular file.
The test I suggested to Chengguang is just a replacement to
rename test under the assumption that if rename would fail with -EXDEV,
link of tempfile will also fail with -EXDEV.

Amir.
