From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: ovl_dir_read_merged: Redundant call to list_add()
Date: Tue, 30 May 2017 14:17:18 +0530
Message-ID: <1956206.WEGzuBeo8p@localhost.localdomain>
References: <1982032.d2FfUCRVGU@localhost.localdomain> <CAOQ4uxhQD_PecXQFLM+7j0wMY9y51NPcw_iOR0gZn9-RZBieOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44605 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750908AbdE3Ir6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 May 2017 04:47:58 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4U8hmYt017979
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2017 04:47:58 -0400
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2as4fc2pfk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2017 04:47:57 -0400
Received: from localhost
        by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 30 May 2017 18:47:55 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
        by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4U8li0k22872312
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2017 18:47:52 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
        by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4U8lCEw027487
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2017 18:47:12 +1000
In-Reply-To: <CAOQ4uxhQD_PecXQFLM+7j0wMY9y51NPcw_iOR0gZn9-RZBieOQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tuesday, May 30, 2017 1:35:55 PM IST Amir Goldstein wrote:
> On Tue, May 30, 2017 at 9:39 AM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > ovl_dir_read_merged() has the following loop,
> >
> >         for (idx = 0; idx != -1; idx = next) {
> >                 next = ovl_path_next(idx, dentry, &realpath);
> >
> >                 if (next != -1) {
> >                         err = ovl_dir_read(&realpath, &rdd);
> >                         if (err)
> >                                 break;
> >                 } else {
> >                         /*
> >                          * Insert lowest layer entries before upper ones, this
> >                          * allows offsets to be reasonably constant
> >                          */
> >                         list_add(&rdd.middle, rdd.list);
> >                         rdd.is_lowest = true;
> >                         err = ovl_dir_read(&realpath, &rdd);
> >                         list_del(&rdd.middle);
> >                 }
> >         }
> >
> >
> > rdd.middle is populated inside ovl_fill_lowest() which is indirectly invoked
> > by the call to ovl_dir_read() inside the "else" part of the above "if"
> > condition. Before this invocation of ovl_dir_read(), rdd.middle would
> > basically be an empty list. So this would mean that the call
> > list_add(&rdd.middle, rdd.list) is unnecessary.
> >
> > Please let me know if I am missing something here.
> >
> 
> You are missing the fact that rdd.middle is not a new list.
> its a list element inserted into the circular list rdd.list as a marker
> to the head of the non-lowest entries list.
> When referencing &rdd.middle inside ovl_fill_lowest() code
> is referencing the same list that was populated in rdd.list,
> but with a different head/tail.
> 
> 

Amir, Thanks for your clarification.

-- 
chandan
