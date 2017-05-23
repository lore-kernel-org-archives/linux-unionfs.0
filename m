From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: constant st_ino/st_dev for non-samefs case
Date: Tue, 23 May 2017 18:49:27 +0530
Message-ID: <4951608.hM2HNRSCh0@localhost.localdomain>
References: <CAOQ4uxhJdyETb96yKr_bRes9OGEeHSOUAH=L4nfX3c2ryYD6Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933347AbdEWNUP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 May 2017 09:20:15 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4NDJ3xv014067
        for <linux-unionfs@vger.kernel.org>; Tue, 23 May 2017 09:20:09 -0400
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2amn1ntunk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Tue, 23 May 2017 09:20:08 -0400
Received: from localhost
        by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 23 May 2017 23:20:03 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
        by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4NDJpkS4325682
        for <linux-unionfs@vger.kernel.org>; Tue, 23 May 2017 23:19:59 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
        by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4NDJPiG024506
        for <linux-unionfs@vger.kernel.org>; Tue, 23 May 2017 23:19:25 +1000
In-Reply-To: <CAOQ4uxhJdyETb96yKr_bRes9OGEeHSOUAH=L4nfX3c2ryYD6Mw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tuesday, May 23, 2017 6:27:42 PM IST Amir Goldstein wrote:
> On Wed, May 17, 2017 at 3:46 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > On Wednesday, May 17, 2017 5:56:31 PM IST Amir Goldstein wrote:
> >> On Wed, May 17, 2017 at 2:42 PM, Chandan Rajendra
> 
> >> There is actually one task that should be very simple to do and can also
> >> bring large benefit for many users.
> >>
> >> In his pull request for kernel 4.12 Miklos writes:
> >> "The biggest part of this is making st_dev/st_ino on the overlay behave like a
> >> normal filesystem ... future work will move the general case towards more sane
> >> behavior."
> >> https://marc.info/?l=linux-unionfs&m=149442365202823&w=2
> >>
> >> The work towards constant st_dev/st_ino for the general case is not within my
> >> immediate scope of interest, but it shouldn't be hard. The basic idea was
> >> explained by  Miklos here:
> >> https://marc.info/?l=linux-unionfs&m=149259338809700&w=2
> >>
> > Amir, I will work on this task. Thanks for the guidance.
> >
> 
> Hi Chandan,
> 
> Were you able to figure out the scope of the task?
> Or didn't get around to it yet?

Hi Amir,

I spent time understanding current overlayfs code. I am now starting to
work on the problem statement.

I should be able to post the patches to the mailing list by the end of 
this week.

> 
> I forgot to mention that I have written tests to cover constant inode
> across copy up.
> If you have never used unionmount-testsuite before, now would be a good time to
> start.
> 
> You should pull my master branch from github:
> https://github.com/amir73il/unionmount-testsuite
> 
> Just do:
> # cd unionmount-testsuite
> # sudo ./run --ov
> 
> It takes only ~13 sec for the basic test run to compete on my laptop.
> 
> Then, you should remove the relaxing of constant ino check for non samefs:
> https://github.com/amir73il/unionmount-testsuite/commit/958b737a0a886b6949964d51dbf8e0786ea52d02#diff-2d2badb93764e2d3fa25662025095014R496
> 
> And you will hit the ino check error, for example:
> 
> # sudo ./run --ov rename-file
> ***
> *** ./run --ov --ts=0 rename-file
> ***
> TEST rename-file.py:10: Rename file and rename back
>  ./run --rename /mnt/a/foo100 /mnt/a/no_foo100
> /mnt/a/no_foo100: inode number wrong (got 35985, want 35584)
> 
> 
> Please let me know if you intend to work on this soon, because I may be
> working on some parts of this task for a different feature.
> 
> Thanks,
> Amir.
> 
> 


-- 
chandan
