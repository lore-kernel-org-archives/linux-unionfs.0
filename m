From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2] fs: add file_dentry()
Date: Wed, 23 Mar 2016 15:14:42 +0100
Message-ID: <CAJfpegt2j2KZBA-fs3r5TVCP=C4zmd-EQq1ocxqFF5ssLvvVEw@mail.gmail.com>
References: <20160323133606.GF11906@tucsk>
	<CAJ75kXZ+QFait-h--dAixE462XL00frBCxnvSBN+rQo3nSXrEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34977 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbcCWOOt (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 23 Mar 2016 10:14:49 -0400
Received: by mail-oi0-f50.google.com with SMTP id w20so21811455oia.2
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Mar 2016 07:14:49 -0700 (PDT)
In-Reply-To: <CAJ75kXZ+QFait-h--dAixE462XL00frBCxnvSBN+rQo3nSXrEw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: William Dauchy <wdauchy@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Theodore Ts'o <tytso@mit.edu>, Daniel Axtens <dja@axtens.net>, stable <stable@vger.kernel.org>

On Wed, Mar 23, 2016 at 3:06 PM, William Dauchy <wdauchy@gmail.com> wrote:
> 4bacc9c9234c ("overlayfs: Make f_path always point to the overlay and
> f_inode to the underlay").
> This commit is from v4.1 if I am not wrong. So the stable tag might be wrong.
>
> Am I missing something?

Use "--contains", otherwise "git describe" will just say which kernel
the patch has been committed to, not which release it appears in.

git describe --contains 4bacc9c9234c
v4.2-rc1~2^2~27

Thanks,
Miklos
