From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] overlay: test ro/rw fd data inconsistecies
Date: Tue, 29 Nov 2016 19:37:15 +0800
Message-ID: <20161129113715.GN22989@eguan.usersys.redhat.com>
References: <1480018332-16567-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgEgNJtFfauUTXAr9YedbJeNFrZaWAUbEJUzycf=r3Emw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933385AbcK2LhR (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Nov 2016 06:37:17 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgEgNJtFfauUTXAr9YedbJeNFrZaWAUbEJUzycf=r3Emw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Nov 29, 2016 at 10:53:36AM +0200, Amir Goldstein wrote:
> On Thu, Nov 24, 2016 at 10:12 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > Introduce a new test to demonstrates a known issue with overlayfs:
> > - process A opens file F for read
> > - process B writes new data to file F
> > - process A reads old data from file F
> >
> > This issue is about to be fixed with a patch set by Miklos Szeredi.
> 
> Eryu and all,
> 
> I wanted to ask what is the common practice for introducing tests for
> know issues
> that are *about* to be solved.
> 
> What is the preferred timing for merging these sort of tests?
> Is it productive to have these tests merged before a fix is merged to master?
> Before a fix is queued for next?
> Before a fix is available?

Basically new regression tests will be merged as soon as possible, as
long as there're no objections from reviewers or all comments are
addressed.

One exception is that for tests that could crash latest maintainer's
tree (even there's a known fix), I'd perfer letting the fix go upstream
first, so that the test doesn't break anyone's tests by crashing all the
testing hosts. It's great if the test author could give a notification
on the test to say that the fix has been merged, so the test could be
merged too. I'll watch the patch status too, but maybe not so timely.

> 
> I am asking because there are several known issues for overlayfs
> whose fixes are in several different states of maturity and I would like
> to know how to treat the tests I write for them.

Thanks for writing test cases! You can send them out at anytime :)

> 
> FYI, the fix for the test in this patch (test ro/rw fd data inconsistencies)
> is not queued for next yet, but I am hoping it will be.
> Miklos?

FYI, this test is already in my last pull request to Dave.

Thanks,
Eryu
