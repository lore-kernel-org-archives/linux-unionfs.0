From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: Overlayfs TODOs
Date: Wed, 17 May 2017 18:16:07 +0530
Message-ID: <3385315.J8HfPLhZLT@localhost.localdomain>
References: <3729499.au3bfvH429@localhost.localdomain> <CAOQ4uxh+wpNX=Zc8AWOgy3EG5Nn_8omv7HZOgngyfGUY_AsFHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54168 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753826AbdEQMqp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 May 2017 08:46:45 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4HCho0N070956
        for <linux-unionfs@vger.kernel.org>; Wed, 17 May 2017 08:46:44 -0400
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2agck6kd3e-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Wed, 17 May 2017 08:46:44 -0400
Received: from localhost
        by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 17 May 2017 22:46:41 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4HCkUoe3211614
        for <linux-unionfs@vger.kernel.org>; Wed, 17 May 2017 22:46:38 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
        by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4HCjxjN028127
        for <linux-unionfs@vger.kernel.org>; Wed, 17 May 2017 22:45:59 +1000
In-Reply-To: <CAOQ4uxh+wpNX=Zc8AWOgy3EG5Nn_8omv7HZOgngyfGUY_AsFHA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wednesday, May 17, 2017 5:56:31 PM IST Amir Goldstein wrote:
> On Wed, May 17, 2017 at 2:42 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> >
> > I am keen on working on overlayfs. It would be very helpful if you could
> > provide me a list of Todo items associated with Overlayfs.
> >
> 
> This is the TODO list that I maintain on wiki:
> https://github.com/amir73il/overlayfs/wiki/Overlayfs-TODO
> 
> It includes at least most of the tasks that are in Miklos' head:
> https://marc.info/?l=linux-unionfs&m=149441099931390&w=2
> 
> My focus right now is all the "non stared" tasks for "same fs" configuration,
> aiming for kernel 4.13.
> 
> Is there are specific area of interest for you with overlayfs?
> Any specific configuration or use case? Or is the interest purely academic?
> 
> I suppose you are looking to start of with smaller tasks?
> 
> There is actually one task that should be very simple to do and can also
> bring large benefit for many users.
> 
> In his pull request for kernel 4.12 Miklos writes:
> "The biggest part of this is making st_dev/st_ino on the overlay behave like a
> normal filesystem ... future work will move the general case towards more sane
> behavior."
> https://marc.info/?l=linux-unionfs&m=149442365202823&w=2
> 
> The work towards constant st_dev/st_ino for the general case is not within my
> immediate scope of interest, but it shouldn't be hard. The basic idea was
> explained by  Miklos here:
> https://marc.info/?l=linux-unionfs&m=149259338809700&w=2
> 
Amir, I will work on this task. Thanks for the guidance.

> 
> 
> Cheers,
> Amir.
> 
> 

-- 
chandan
