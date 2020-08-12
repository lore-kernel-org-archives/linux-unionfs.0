Return-Path: <SRS0=do5T=BW=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958DAC433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 17:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DEC620774
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 17:30:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QzvkoNIl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgHLRam (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 13:30:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726531AbgHLRal (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Aug 2020 13:30:41 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07CH48aO107971;
        Wed, 12 Aug 2020 13:30:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : date : mime-version : in-reply-to : content-type :
 content-transfer-encoding : message-id; s=pp1;
 bh=Q/ZzrFt0OJ8hoicx73D2ZPqFWPbrx2NndGD2zS95Aos=;
 b=QzvkoNIl5LSnlMhmKKLlVc9LLl6N8bZrMt8MsMwoY7x9Ln61qS+lrMmrIOLMkHVEtIGO
 wRi5L2L9GQLllc3cx3UNHWtjKHSmPelbz+sFR8KzQoiz+6r6v1YhpRZiQPCF6DtA4tzX
 dF1lt84daKgE9lS+KPD+g66+1QctmbhGBaIVZM62lD7Xy6+89idneC8E+LawfGHvm5Fk
 WmwyUTxpxCppYCdjEO6uFvgOT9wtUOyMxzFwA/l2KF2+dP68klwTveAIcTmH8Hv33MjU
 3G5UdqH3Aveat2YwgvHE3e2X4b3mvet8KJ3qJhuOMQcSFVDUYyBMRxjmlgzzGCh/2jvA JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32vf4pbsu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 13:30:29 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07CH4eCg111271;
        Wed, 12 Aug 2020 13:30:29 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32vf4pbsta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 13:30:29 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07CHKINo003932;
        Wed, 12 Aug 2020 17:30:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 32skp84nmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 17:30:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07CHUPFi22675826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 17:30:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25140A406A;
        Wed, 12 Aug 2020 17:30:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ADB0A4060;
        Wed, 12 Aug 2020 17:30:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.33.217])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Aug 2020 17:30:24 +0000 (GMT)
Subject: Re: Getting WIP aops branch(ovl-aops-wip) in shape for merging.
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
References: <20200313140843.5C65542045@d06av24.portsmouth.uk.ibm.com>
 <CAOQ4uxgabS0GMaMXHbhXoBv9OXAZv9O2WzZ-h9aWhZm6quASOg@mail.gmail.com>
 <20200812140012.875A711C089@d06av25.portsmouth.uk.ibm.com>
 <CAOQ4uxhf6R2Gr1wV_LGbAuDGuuPmnb0Mvx43MxWc2O1gQkrGUQ@mail.gmail.com>
 <20200812170001.50BA6A4067@b06wcsmtp001.portsmouth.uk.ibm.com>
 <CAOQ4uxj7JzmKdrV5Z2AHFFk09OwJL_djjE=JOxVOxQU8HVFkVg@mail.gmail.com>
From:   Ritesh Harjani <riteshh@linux.ibm.com>
Date:   Wed, 12 Aug 2020 23:00:23 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj7JzmKdrV5Z2AHFFk09OwJL_djjE=JOxVOxQU8HVFkVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Message-Id: <20200812173024.4ADB0A4060@b06wcsmtp001.portsmouth.uk.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_12:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 clxscore=1011 priorityscore=1501 bulkscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120110
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 8/12/20 10:44 PM, Amir Goldstein wrote:
>> Sure. So here is what I was planning.
>> I am about to start going over patches mentioned in Amir's ovl-aops-wip
>> branch. My first preference would be to port it to latest upstream and
>> start cleaning it up.
>> I will update the branch details once those patches are ported to
>> latest upstream. Let me know if we should do this in any different way.
>>
> 
> Sounds like a plan.
> 
>> I will also be joining this year's plumber, in case if we want
>> to discuss anything on this. Although I am not sure if by then, I would
>> be able to get any substantial work done to discuss with a wider
>> audience. But nevertheless, we can always have a call/email exchanges
>> for this, both before and after the conference :)
>>
> 
> Nice. I will be giving a talk on new overlayfs features on the containers track.
> I guess there won't be much in the hallway tracks this year...
> 

Nice, looking forward to this!!

-ritesh
