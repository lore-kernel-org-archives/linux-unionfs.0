From: "J . Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 0/7] More NFS file handle unit tests
Date: Tue, 7 Nov 2017 15:05:02 -0500
Message-ID: <20171107200502.GD24262@fieldses.org>
References: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:48618 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932834AbdKGUFD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 15:05:03 -0500
Content-Disposition: inline
In-Reply-To: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Thu, Nov 02, 2017 at 12:15:32PM +0200, Amir Goldstein wrote:
> Eryu,
> 
> This series enhances test coverage for generic NFS file handles
> encode/decode functionality and adds a new gereric/exportfs test.

Look fine to me.

My only worry is the reliance on drop_caches.  It doesn't really
guarantee that the dentries will diseappear.  But I think we've had that
discussion before, and anyway that problem predates these patches.

--b.
