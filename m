From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V3] ovl: Allocate anonymous devs for lowerdirs
Date: Thu, 27 Jul 2017 11:54:15 +0530
Message-ID: <2098530.dS0XS0MFtf@localhost.localdomain>
References: <CAJfpegs9W=qQRXBeF7h4t4bxnXvbGnTbUi+iGaZhft79Mvxgtw@mail.gmail.com> <20170724091722.23252-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40669 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751451AbdG0GXx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Jul 2017 02:23:53 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6R6JLYj107125
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Jul 2017 02:23:52 -0400
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2by8vamxcu-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Jul 2017 02:23:52 -0400
Received: from localhost
        by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 27 Jul 2017 16:23:49 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
        by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6R6NlZO28246250
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Jul 2017 16:23:47 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
        by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v6R6Nc6e009530
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Jul 2017 16:23:38 +1000
In-Reply-To: <20170724091722.23252-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

On Monday, July 24, 2017 2:47:22 PM IST Chandan Rajendra wrote:
> For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
> provides unique values for st_dev. The unique values are obtained by
> allocating anonymous bdevs for each of the lowerdirs in the overlayfs
> instance.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
> Changelog:
> 
> v2->v3: Optimize away O(n) search for pseudo dev in ovl_get_pseudo_dev().
> 
> v1->v2: Drop code that provided unique st_dev across copy up.
> 

I have rebased Amir's "ovl: relax same fs constrain for constant st_ino" 
patch on top of the changes made in this patch. The tree containing
the rebased patch can be found at 
"https://github.com/chandanr/linux.git rework-anonymous-dev"

I have tested this by executing unionmount-testsuite's "./run --ov --verify".

-- 
chandan
