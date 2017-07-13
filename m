From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] check_layer: Add tests for constant st_dev
Date: Thu, 13 Jul 2017 19:47:52 +0530
Message-ID: <10642288.FqVSjOuREu@localhost.localdomain>
References: <20170704170028.4278-1-chandan@linux.vnet.ibm.com> <CAOQ4uxjuKCGGK1shB1YO3Ony5Gqcv_mm7kidoeO8mgvnTqi7kw@mail.gmail.com> <CAOQ4uxicgyZRKxBVv+KTU8jQ0g7kSS7TWcjpNj8v5Za_gsP9iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54595 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751337AbdGMORf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2017 10:17:35 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6DEFbAi195030
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2017 10:17:29 -0400
Received: from e23smtp05.au.ibm.com (e23smtp05.au.ibm.com [202.81.31.147])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bnt3ptb9q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2017 10:17:28 -0400
Received: from localhost
        by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 14 Jul 2017 00:17:26 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6DEHNHb25559120
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Jul 2017 00:17:23 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
        by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v6DEHE1w015581
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Jul 2017 00:17:15 +1000
In-Reply-To: <CAOQ4uxicgyZRKxBVv+KTU8jQ0g7kSS7TWcjpNj8v5Za_gsP9iA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Saturday, July 8, 2017 1:42:41 PM IST Amir Goldstein wrote:
> OK, my pseudo patch was mostly correct, but full of brainoes,
> push a tested patch to
> https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
> 
> Please review and verify.
> 


Hi Amir,

'./run --ov' on 'next' kernel (i.e. the one containing code which returns
pseudo st_devs for files on lowerdir) fails as shown below,

$ ./run --ov
***
*** ./run --ov --ts=0 open-plain
***
TEST open-plain.py:10: Open O_RDONLY
/mnt/a/foo100: File not on lower/upper layer

The corresponding code from check_layer() is,

            elif dev != self.upper_fs() and dev != self.lower_fs():
                raise TestError(name + ": File not on lower/upper layer")


This happens due to open-plain.py's subtest_1() opening a file on lowerdir in
read-only mode (i.e. copy-up does not occur). Later, stat(2) invocation from
check_layer() would end up returning the pseudo st_dev corresponding to
lowerdir.


'./run --ov --samefs --verify' on 4.12 kernel fails as shown below,

$ ./run --ov --samefs --verify
***
*** ./run --ov --ts=0 hard-link
***
TEST hard-link.py:10: Hard link file
./run --link /mnt/a/foo100 /mnt/a/no_foo100
/mnt/a/no_foo100: inode number wrong (got 39001, want 37581)

The failure happens because the dentry representing the new hard link wouldn't
have __OVL_PATH_ORIGIN set.

-- 
chandan
