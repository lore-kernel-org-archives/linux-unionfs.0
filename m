Return-Path: <SRS0=xPSr=CF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 506E0C433E3
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224A920738
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fElF30SI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgH0HhD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:37:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726851AbgH0HhD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Aug 2020 03:37:03 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R7YfEW091396;
        Thu, 27 Aug 2020 03:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : date : mime-version : in-reply-to : content-type :
 content-transfer-encoding : message-id; s=pp1;
 bh=kYOKYTB7+jJSb2719mx2TwmSPgVtsOq/5kBCVDgH7tg=;
 b=fElF30SIvZSIrua+NBfliZ+dbprNCoZUfvjUzl/JqPrLpvM0meXgpL/VXFqcBOIETfVR
 BRV3age2pHA2gTvizkTcEf3hDxSlqXl/0ikUElNBbgm+nRgvHjhzfON55Rs1jYPv0EAu
 obMLIaxLXUsSzJFHnyScxER9XHobSJJoIiQhsahzUyFr8iJnHOp45XfVMjTD1TuAvqhe
 Lp4trEyn+czVNh8g3iBJLX+c7h084RRfs2nlZZYlgO4rLfu5shB+wLYCQUsBKHrtZxK6
 97Y/8m6wuI8sfL5jTEUE4D+IjQ3Fa2+zuLYWK+uKPGhFDc0qSOrR74kfO2SAfG6t55hw bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 336620m70q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 03:36:53 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07R7Zqsj096268;
        Thu, 27 Aug 2020 03:36:53 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 336620m6yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 03:36:52 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R7XAuh017973;
        Thu, 27 Aug 2020 07:36:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 332ujkwdg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 07:36:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R7amJZ28246380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 07:36:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67F7452050;
        Thu, 27 Aug 2020 07:36:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.43.157])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 66DEC52051;
        Thu, 27 Aug 2020 07:36:47 +0000 (GMT)
Subject: Re: Getting WIP aops branch(ovl-aops-wip) in shape for merging.
To:     Amir Goldstein <amir73il@gmail.com>,
        Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
References: <20200313140843.5C65542045@d06av24.portsmouth.uk.ibm.com>
 <CAOQ4uxgabS0GMaMXHbhXoBv9OXAZv9O2WzZ-h9aWhZm6quASOg@mail.gmail.com>
 <20200812140012.875A711C089@d06av25.portsmouth.uk.ibm.com>
 <CAOQ4uxhf6R2Gr1wV_LGbAuDGuuPmnb0Mvx43MxWc2O1gQkrGUQ@mail.gmail.com>
 <20200812170001.50BA6A4067@b06wcsmtp001.portsmouth.uk.ibm.com>
 <CAOQ4uxj7JzmKdrV5Z2AHFFk09OwJL_djjE=JOxVOxQU8HVFkVg@mail.gmail.com>
 <20200826142714.2CA0FAE067@d06av26.portsmouth.uk.ibm.com>
 <CAOQ4uxjCPQF4LxE4kmMuOf3sa7Xrkcm-ZvdjBBtKgNWjY7Qb6g@mail.gmail.com>
From:   Ritesh Harjani <riteshh@linux.ibm.com>
Date:   Thu, 27 Aug 2020 13:06:46 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjCPQF4LxE4kmMuOf3sa7Xrkcm-ZvdjBBtKgNWjY7Qb6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Message-Id: <20200827073647.66DEC52051@d06av21.portsmouth.uk.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_02:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270053
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 8/27/20 12:12 PM, Amir Goldstein wrote:
> On Wed, Aug 26, 2020 at 5:27 PM Ritesh Harjani <riteshh@linux.ibm.com> wrote:
>>
>> Hello Amir,
>>
>> On 8/12/20 10:44 PM, Amir Goldstein wrote:
>>>> Sure. So here is what I was planning.
>>>> I am about to start going over patches mentioned in Amir's ovl-aops-wip
>>>> branch. My first preference would be to port it to latest upstream and
>>>> start cleaning it up.
>>>> I will update the branch details once those patches are ported to
>>>> latest upstream. Let me know if we should do this in any different way.
>>>>
>>>
>>> Sounds like a plan.
>>>
>>>> I will also be joining this year's plumber, in case if we want
>>>> to discuss anything on this. Although I am not sure if by then, I would
>>>> be able to get any substantial work done to discuss with a wider
>>>> audience. But nevertheless, we can always have a call/email exchanges
>>>> for this, both before and after the conference :)
>>>>
>>>
>>> Nice. I will be giving a talk on new overlayfs features on the containers track.
>>> I guess there won't be much in the hallway tracks this year...
>>
>>
>> I went over almost all patches which you have in ovl-aops-wip branch.
>> For now I have only ported some of the straight forward patches,
>> since I had few queries on those other patches and one was mainly
>> w.r.t. metadata only feature functionality.
>>
> 
> Those questions you can also ask Vivek if you find him in LPC...

Sure, thanks. Will try to check with Vivek.

> 
>> Do you have sometime today to discuss about it in any of the LPC hacker
>> room? I was thinking maybe discussing this in person will help a lot.
>>
> 
> I agree that a video meetup can be useful to kickoff this effort, but
> it is preferred if Chengguang can also attend, because it feels like
> you guys need to collaborate.
> 
>> Any preferred slot? I could not find you online on LPC chat area,
>> we can as well discuss the slot there. But I am fine with any of the LPC
>> timings.
>>
> 
> I cannot do LPC times today or tomorrow, but the hacker rooms are
> open and judging by the time of your email you may be closer to my
> time zone, so if you want to schedule a meeting somewhere in the next
> 5 hours, I can join. (7:00-12:00 UTC).
> 
> Otherwise, we can always schedule a call outside of LPC, where
> participants not registered to LPC will be able to join (Chengguang?).
> 

I agree. Yes, 7:00 - 12:00 UTC works for me.

@Chengguang,
Could you please tell if 7:00 - 12:00 UTC works for you? If yes, then
shall we meet once to discuss about aops implementation for overlayfs.
Is today 11:am UTC ok with you? If yes, then shall we meet today using
below link?

https://meet.google.com/txn-hbjg-zgx


-ritesh

