Return-Path: <SRS0=JJdx=CE=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D53C433E1
	for <linux-unionfs@archiver.kernel.org>; Wed, 26 Aug 2020 14:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23ACB21741
	for <linux-unionfs@archiver.kernel.org>; Wed, 26 Aug 2020 14:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XMW6vQSN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgHZO1w (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 10:27:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12214 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728014AbgHZO1q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Aug 2020 10:27:46 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07QE58hV003648;
        Wed, 26 Aug 2020 10:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : date : mime-version : in-reply-to : content-type :
 content-transfer-encoding : message-id; s=pp1;
 bh=m5ebrNsJVLyfnzJc6VRt/EXOtfTlXR90ohOqLIyFJ1M=;
 b=XMW6vQSN1xfmqG+U30YjqEQcPfr/OUoIcyGRv0rfOu+SQgd/Vk/kNnF4CNtj0EHR1SVN
 iuUQgCRZjFlqj7wgsr9CzHkEGttfrM6mnnmumdj5EBWdMEyLP0cNJMLBgsRQnXNww3At
 yQkmdaxRXi0H3u2ABjm5sUuyu7xbcnWyEY/KFDHBmxHSrvaIfY1SvwE5Wx8wCuUU2/yy
 hEVKhYe1KAwsuS31JPqM/Vsn/P39cW1yBPa2BsG+wfwmPX1gQMDetuK35oBj2Vj1NaR4
 hzBqQSmUy8ISu/dEtlxsLWnmi7az35Akurz6/tl68NnzAU8Mlm+8Atfog9j8oIr4hL34 Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 335rmva4s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Aug 2020 10:27:20 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07QE5GdL004626;
        Wed, 26 Aug 2020 10:27:19 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 335rmva4r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Aug 2020 10:27:19 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07QEMqmV023217;
        Wed, 26 Aug 2020 14:27:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 332uk6cnm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Aug 2020 14:27:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07QERFeD59179456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 14:27:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45E60AE053;
        Wed, 26 Aug 2020 14:27:15 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CA0FAE067;
        Wed, 26 Aug 2020 14:27:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.43.157])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Aug 2020 14:27:13 +0000 (GMT)
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
Date:   Wed, 26 Aug 2020 19:57:12 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj7JzmKdrV5Z2AHFFk09OwJL_djjE=JOxVOxQU8HVFkVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Message-Id: <20200826142714.2CA0FAE067@d06av26.portsmouth.uk.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_09:2020-08-26,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 clxscore=1015 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260106
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello Amir,

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


I went over almost all patches which you have in ovl-aops-wip branch.
For now I have only ported some of the straight forward patches,
since I had few queries on those other patches and one was mainly
w.r.t. metadata only feature functionality.

Do you have sometime today to discuss about it in any of the LPC hacker
room? I was thinking maybe discussing this in person will help a lot.

Any preferred slot? I could not find you online on LPC chat area,
we can as well discuss the slot there. But I am fine with any of the LPC
timings.

-ritesh
