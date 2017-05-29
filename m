From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: Re: [PATCH REGRESSION 4.12-rc1] ovl: add missing CONFIG_EXPORTFS
 dependency
Date: Mon, 29 May 2017 09:52:19 +0200
Message-ID: <20170529095219.7114568b@gmail.com>
References: <20170516101139.29847-1-ralph.sennhauser@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34977 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbdE2Hw1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 29 May 2017 03:52:27 -0400
In-Reply-To: <20170516101139.29847-1-ralph.sennhauser@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 16 May 2017 12:11:39 +0200
Ralph Sennhauser <ralph.sennhauser@gmail.com> wrote:

> The source files namei.c and copy_up.c in overlayfs new use
> exportfs_decode_fh which depends on CONFIG_EXPORTFS being set. Select
> it in Kconfig.

This issue is still present in 4.12-rc3

Ralph
