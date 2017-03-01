From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v5 0/10] fstests: new way to run overlay tests
Date: Wed, 1 Mar 2017 11:47:36 +0800
Message-ID: <20170301034736.GC14226@eguan.usersys.redhat.com>
References: <1488284317-3119-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751824AbdCAErM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Feb 2017 23:47:12 -0500
Content-Disposition: inline
In-Reply-To: <1488284317-3119-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Feb 28, 2017 at 02:18:27PM +0200, Amir Goldstein wrote:
> Hi Eryu,
> 
> I rebased my branch to your master and made some minor adaptations
> to Xiong's new tests. Also reordered the patches:

Thanks for the resending! I was about to ask for it :)

> 
> - patches 1-6 are generic fixes and re-factoring - if you wish,
>   you can merge them before the overlay config changes.
> 
> - patches 7-10 implement the new overlay config. patches 7 and 10
>   include adaptations of Xiong's new tests to new config.
> 
> This is the 5th revision of new overlayfs config.
> The main motivation of this work is to help catch overlayfs bugs
> related to leaking objects in underlying (base) fs.
> 
> With this change, all you have to do to run overlay tests if you
> already have a local.config setup to test a local file system is:
>  ./check -overlay
> 
> See README.overlay for some examples of config files to use with -overlay.
> 
> The legacy overlayfs configuration, where TEST_DEV is a directory
> still works, but it should be deprecated.
> 
> Tested ./check -overlay -g quick with both legacy overlay configuration
> and the new base fs configuration.
> 
> Eryu wished to keep these changes soaking on the list for while,
> so for those who can help with testing, you can get pull the branch
> for testing from my github tree [1].

I was planning to pull them in via this week's update, if there's no
objections.

Thanks again for the work!

Eryu
