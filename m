From: William Dauchy <wdauchy@gmail.com>
Subject: Re: [PATCH v2] fs: add file_dentry()
Date: Wed, 23 Mar 2016 15:24:05 +0100
Message-ID: <CAJ75kXZHT2g6CkDjYzHeBVHoudRoRWTMvxp69-YEY7+3VoFh4Q@mail.gmail.com>
References: <20160323133606.GF11906@tucsk> <CAJ75kXZ+QFait-h--dAixE462XL00frBCxnvSBN+rQo3nSXrEw@mail.gmail.com>
 <CAJfpegt2j2KZBA-fs3r5TVCP=C4zmd-EQq1ocxqFF5ssLvvVEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lb0-f194.google.com ([209.85.217.194]:35251 "EHLO
	mail-lb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbcCWOY1 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 23 Mar 2016 10:24:27 -0400
In-Reply-To: <CAJfpegt2j2KZBA-fs3r5TVCP=C4zmd-EQq1ocxqFF5ssLvvVEw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Theodore Ts'o <tytso@mit.edu>, Daniel Axtens <dja@axtens.net>, stable <stable@vger.kernel.org>

On Wed, Mar 23, 2016 at 3:14 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Use "--contains", otherwise "git describe" will just say which kernel
> the patch has been committed to, not which release it appears in.
>
> git describe --contains 4bacc9c9234c
> v4.2-rc1~2^2~27

Indeed; I saw the patch in v4.1.x stable
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/fs/internal.h?h=linux-4.1.y&id=9abb3b81094857a1e2d7dea5b2a8605e29d8c77d

-- 
William
