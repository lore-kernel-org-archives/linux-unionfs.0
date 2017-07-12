From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 5/5] overlay: test mount error cases with exclusive
 directories
Date: Wed, 12 Jul 2017 18:47:42 +0800
Message-ID: <20170712104741.GD7015@eguan.usersys.redhat.com>
References: <1499802726-11045-1-git-send-email-amir73il@gmail.com>
 <1499802726-11045-6-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750959AbdGLKro (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jul 2017 06:47:44 -0400
Content-Disposition: inline
In-Reply-To: <1499802726-11045-6-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jul 11, 2017 at 10:52:06PM +0300, Amir Goldstein wrote:
> Expect EBUSY when trying to mount overlay when:
> - Upper dir is in-use by another overlay mount
> - Work dir is in-use by another overlay mount
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

>From patch 2/5, seems this behavior requires inode index feature to be
enabled, and now test fails on old kernels for me. Is this expected?

Thanks,
Eryu
