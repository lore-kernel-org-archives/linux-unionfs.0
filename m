From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH][RFC] Run unionmount testsuite with new overlay/union
 test group
Date: Wed, 5 Jul 2017 19:10:49 +0800
Message-ID: <20170705111049.GT23360@eguan.usersys.redhat.com>
References: <1499170451-24596-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751966AbdGELKv (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2017 07:10:51 -0400
Content-Disposition: inline
In-Reply-To: <1499170451-24596-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jul 04, 2017 at 03:14:11PM +0300, Amir Goldstein wrote:
> This test group requires that unionmount-testsuite is installed
> under src dir.
> 
> These tests use tmpfs and have no need for test nor scratch partition.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Eryu,
> 
> unionmount-testsuite, written by David Howells, is a powerfull tool for
> validating "union mounts", which nowadays, mostly means overlayfs.
> 
> The testsuite was enhanced with directory rename tests for kernel v4.10,
> and with constant inode number verification for kernel v4.12.
> The most recent repository is maintained on my github [1].

Are you planning to push all your enhancements to upstream? Red Hat QE
is using unionmount-testsuite to test overlayfs :) But it's downloaded
from David's repo[1], which hasn't been updated for two years.

[1] git://git.infradead.org/users/dhowells/unionmount-testsuite.git

> 
> The tool is written in python. By default, it uses tmpfs for the
> overlayfs layers and a complete run of all the tests in the most
> basic configuration takes ~10 seconds on my laptop.
> 
> I have been using xfstests as a test harness to run unionmount-testsuite
> with several configuration (e.g. layers on same/non-same fs) and I am quite
> certain that more people can benefit from this setup.
> 
> The proposed patch is how I use the harness, but it raises some questions:
> - How does xfstests community feel about relying on external repositories?

I'd like to see either porting all the tests from external repositories
to fstests or keeping them separate as they're two independent
testsuites. I'm reluctant to make fstests rely on an external testsuite
and make fstests a wrapper of it. I think it's easier to maintain for
both projects, and things are simpler this way and well self-contained.

> - How does xfstests community feel about including python sources in the
>   xfstests repository?

I think it's OK to include python sources if it's really needed. But we
tend to not add more dependencies to fstests, if we have better choice,
e.g. use perl instead. There's only one python script right now,
tools/sort-group, but it's not used by the tests.

Thanks,
Eryu

> 
> There are probably very few, if any, people running the testsuite, besides
> Miklos and myself and I personally have no strong preference towards
> maintaining the tool in an external repository or in xfstests repository.
> 
> Thoughts?
> 
> Amir.
> 
> [1] https://github.com/amir73il/unionmount-testsuite
