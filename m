From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 00/11] overlayfs constant inode numbers
Date: Tue, 25 Apr 2017 08:16:20 -0400
Message-ID: <20170425121620.GB11500@redhat.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1045216AbdDYMQW (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Apr 2017 08:16:22 -0400
Content-Disposition: inline
In-Reply-To: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Apr 24, 2017 at 12:14:05PM +0300, Amir Goldstein wrote:
> Miklos,
> 
> Following your comments on the 'stable inodes' series from last week,
> this series fixes constant inode numbers for stat(2) with any layer
> configuration.
> 
> For the case of all *lower* layers on same fs that supports NFS export,
> redirect by file handle will be used to optimize the lookup of the copy
> up origin of non-dir inode.

I was trying to run unionmount-testsuite (original from dhowells) and I
disabled layer check. Looks like empty directory rename test fails.

***
*** ./run --ov --ts=0 rename-empty-dir
***
TEST rename-empty-dir.py:10: Rename empty dir and rename back
 ./run --rename /mnt/a/empty100 /mnt/a/no_dir100
 /mnt/a/empty100: Unexpected error: Invalid cross-device link

Vivek
