From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: ovl_dir_read_merged: Redundant call to list_add()
Date: Tue, 30 May 2017 12:09:56 +0530
Message-ID: <1982032.d2FfUCRVGU@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750720AbdE3Gkc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 May 2017 02:40:32 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4U6cfPM131929
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2017 02:40:31 -0400
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2aryg3785c-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2017 02:40:31 -0400
Received: from localhost
        by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 30 May 2017 16:40:28 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4U6eHtw60751976
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2017 16:40:25 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
        by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4U6dktx023937
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2017 16:39:46 +1000
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>

ovl_dir_read_merged() has the following loop,

        for (idx = 0; idx != -1; idx = next) {
                next = ovl_path_next(idx, dentry, &realpath);

                if (next != -1) {
                        err = ovl_dir_read(&realpath, &rdd);
                        if (err)
                                break;
                } else {
                        /*                                                                                                                                                                                                                     
                         * Insert lowest layer entries before upper ones, this                                                                                                                                                                 
                         * allows offsets to be reasonably constant                                                                                                                                                                            
                         */
                        list_add(&rdd.middle, rdd.list);
                        rdd.is_lowest = true;
                        err = ovl_dir_read(&realpath, &rdd);
                        list_del(&rdd.middle);
                }
        }


rdd.middle is populated inside ovl_fill_lowest() which is indirectly invoked
by the call to ovl_dir_read() inside the "else" part of the above "if"
condition. Before this invocation of ovl_dir_read(), rdd.middle would
basically be an empty list. So this would mean that the call
list_add(&rdd.middle, rdd.list) is unnecessary.

Please let me know if I am missing something here.

-- 
chandan
