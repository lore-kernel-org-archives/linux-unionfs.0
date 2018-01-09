From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 06/23] ovl: add support for "verify" feature
Date: Tue, 9 Jan 2018 11:54:13 +0200
Message-ID: <CAOQ4uxiXcpd13wua+=g+Uw=zO=QEy5fUA6zGfDqhx3yyOXVcbA@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-7-git-send-email-amir73il@gmail.com> <CAJfpegvsb66k4hhFQfg5vdMRJyA8kqMypOPwaf=C0DeF+2w5ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:35581 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbeAIJyO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 04:54:14 -0500
Received: by mail-yb0-f180.google.com with SMTP id b18so2357547ybn.2
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 01:54:14 -0800 (PST)
In-Reply-To: <CAJfpegvsb66k4hhFQfg5vdMRJyA8kqMypOPwaf=C0DeF+2w5ew@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jan 9, 2018 at 11:16 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Introduce the "verify" config, module and mount options.
>>
>> If the "verify" feature is enabled then overlay filesystems will use
>> the inodes index dir to verify layers consistency.
>>
>> It is possible to enable consistency verification by default during
>> build time with the OVERLAY_FS_VERIFY config option, during runtime
>> with the "verify=on" module option or on a filesystem instance basis
>> with the "verify=on" mount option.
>>
>> The "verify" feature will prevent multiple redirects to the same lower
>> dir and will prevent broken hardlinks from using the same inode number.
>>
>> On an overlay filesystem instance with multiple lower layers, "verify"
>> feature can only use the index to prevent multiple redirects from upper
>> dirs and not from middle layer dirs. Emit a warning about this on mount
>> with multiple lower layers and "verify=on".
>
> Could the above go into Documentation/filesystems/overlayfs.txt as well?

Will do.
BTW, are you ok with the feature name "verify" or do you prefer that
I rename it to "verify_origin" to be more descriptive as Vivek suggested?

>
> Also, the verify feature does have some overhead, which should also be
> noted in the documentation.  Do you have some measurements about how
> much impact it has on performance?
>

I do not. It's on my TODO list.

I'm curious though, where do you think it should performance?
I would expect that encoding a file handle and index lookup would not be
that expensive, so I don't expect much lookup overhead. No?
For copy up, I doubt that creating 2 dirs instead of one, or 2 hardlinks
instead of one file would make a big difference?
I suppose that a highly concurrent copy workload up will become a little
contended of the index dir lock, but still nowhere near the fully sequential
nature of dir copy up.

"verify" feature will surely have an impact of index directory size.
I do have a concern about the impact of a very large index directory on
index lookup and creation times and I intend to test that.

A very just concern that Vivek raised is performance of overlay mount time.
Apparently, there are some workloads that are sensitive to mount/umount
time in the containers world.
For those workloads, ovl_indexdir_cleanup() could be a problem.
For directory index entries, ovl_verify_index() is decoding the upper dir file
handle and that can be expensive.
The cleanup on mount is not strictly needed for correctness of "verify" feature,
nor for NFS export, so we may want to consider a mount option for not
running ovl_indexdir_cleanup() or for running it in a non expensive mode
that skips the file handle verification?

Thanks,
Amir.
