From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v9 10/15] ovl: A new xattr OVL_XATTR_METACOPY for file on upper
Date: Mon, 8 Jan 2018 16:50:00 +0100
Message-ID: <CAJfpegtc-63zQS+_j1sKB48fXSz63nT4hH0Q09brLWHbaC5KKg@mail.gmail.com>
References: <20171129155448.32721-1-vgoyal@redhat.com> <20171129155448.32721-11-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34983 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934103AbeAHPuB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Jan 2018 10:50:01 -0500
Received: by mail-qk0-f174.google.com with SMTP id w184so6477219qka.2
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Jan 2018 07:50:01 -0800 (PST)
In-Reply-To: <20171129155448.32721-11-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>

On Wed, Nov 29, 2017 at 4:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Now we will have the capability to have upper inodes which might be only
> metadata copy up and data is still on lower inode. So add a new xattr
> OVL_XATTR_METACOPY to distinguish between two cases.

Maybe I missed something, but I think there's a bug in this patch:
truncate() is a metadata+data operation since it affects results of
read().  So it should be handled by doing the data copy-up like we did
before.

Thanks,
Miklos
