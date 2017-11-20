From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/3] More nonsamefs d_ino test cleanups
Date: Mon, 20 Nov 2017 14:28:33 +0530
Message-ID: <4911339.3rRr1GUodZ@localhost.localdomain>
References: <1511092589-29179-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750952AbdKTI5f (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Nov 2017 03:57:35 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAK8sWVq072508
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Nov 2017 03:57:34 -0500
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ebustgs37-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Nov 2017 03:57:34 -0500
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 20 Nov 2017 08:57:32 -0000
In-Reply-To: <1511092589-29179-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Sunday, November 19, 2017 5:26:26 PM IST Amir Goldstein wrote:
> Chandan,
> 
> Please review my cleanups to overlay/041.
> I hope I did not "cleanup" anything important.
> This is the version of the test I used for testing xino feature,
> because it has improved test coverage for subdirs d_ino.
> 

The changes looks good.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

> If you approve of these changes, at least first 2 patches should
> be applied to the samefs test flavor (overlay/038), so the flavor
> difference remains only the layers setup used by the test.
> 
> Let me know if you want me to apply the changes to 038 myself or if
> you intend to do that yourself.

Amir, I will make the changes to overlay/038 and post them soon.

-- 
chandan
