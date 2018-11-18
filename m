Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44650 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbeKSAN3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 18 Nov 2018 19:13:29 -0500
Date: Sun, 18 Nov 2018 21:53:00 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2] overlay: create directory over deleted whiteout
Message-ID: <20181118135300.GF3889@desktop>
References: <20181112094818.3742-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181112094818.3742-1-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Nov 12, 2018 at 10:48:18AM +0100, Miklos Szeredi wrote:
> There's a bug in the overlayfs implementation starting from the very first
> merged version that may cause an Oops of various forms if a directory is
> created over a whiteout dentry, but the actual whiteout on the upper layer
> was removed to the directory creation.
> 
> Reported by: kaixuxia <xiakaixu1987@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks for the resending and fix-up! Thanks to Amir for reviewing as
well :)

Eryu
