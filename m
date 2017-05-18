From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix ovl_rename error handling
Date: Thu, 18 May 2017 16:57:33 +0300
Message-ID: <CAOQ4uxh-EDu=Y+BVfVsve6xDwYsQuHJhx19f=LMpF72LRhow8g@mail.gmail.com>
References: <20170518133500.1890143-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35013 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755473AbdERN5j (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 May 2017 09:57:39 -0400
In-Reply-To: <20170518133500.1890143-1-arnd@arndb.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, May 18, 2017 at 4:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> We try to clean up two objects before they got initialized:
>
> fs/overlayfs/dir.c: In function 'ovl_rename':
> fs/overlayfs/dir.c:1060:2: error: 'newdentry' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> fs/overlayfs/dir.c:891:17: note: 'newdentry' was declared here
> fs/overlayfs/dir.c:1062:2: error: 'olddentry' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> fs/overlayfs/dir.c:890:17: note: 'olddentry' was declared here
>
> Assuming that no special cleanup is required for the new code, the correct
> branch target should be "out_revert_creds" to clean up everything that
> got initialized up to then.
>

Yep, this is correct. You are the 4th to send this patch :)
Thanks
