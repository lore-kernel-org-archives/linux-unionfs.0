From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 06/23] ovl: add support for "verify" feature
Date: Fri, 5 Jan 2018 17:47:36 +0200
Message-ID: <CAOQ4uxg35sutZZUCKQxoiuNVfLXxe44wavX95bC_GMntbLn-QQ@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-7-git-send-email-amir73il@gmail.com> <20180105154323.GC29480@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:42289 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbeAEPrh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 10:47:37 -0500
Received: by mail-yb0-f196.google.com with SMTP id j197so1046785ybg.9
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Jan 2018 07:47:37 -0800 (PST)
In-Reply-To: <20180105154323.GC29480@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 5, 2018 at 5:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jan 04, 2018 at 06:40:01PM +0200, Amir Goldstein wrote:
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
>
> So how does one end up with multiple redirects to same lower dir.
>
> Also what's the issue with broken hardlinks using same inode number. You
> mean lower and upper are on different fs and upper can use same inode
> number? With index=on, broken hardlink issue is taken care of so. So
> why would somebody use verify=on, which looks like will create index
> for all kind of files/dir.
>
> I have not followed this development and there is not much background
> in patch descrition or header patch, so asking all these basic questions.
>

I have a ready answer for you :)
This is how it can happen and this is what can go wrong:
https://github.com/amir73il/xfstests/commit/f3c18125539660329195f142973ea620d6899418

The test duplicates a redirect dir offline with cp -a, but the
same thing can be done with a dir with origin.
In both cases, 'diff' will wrongly report that the files/dir are the same
even though they may differ (after being copied).

Amir.
