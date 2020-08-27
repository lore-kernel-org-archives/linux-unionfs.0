Return-Path: <SRS0=xPSr=CF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6E0C433E1
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A158B20738
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:25:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m4Poc8sL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgH0IZm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:25:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726826AbgH0IZl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Aug 2020 04:25:41 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R8223m120794;
        Thu, 27 Aug 2020 04:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : date : mime-version : in-reply-to : content-type :
 content-transfer-encoding : message-id; s=pp1;
 bh=1bYUCTm9lVzPTFqTEcNbIE6jWDNPcdOal0DGyMMgM0w=;
 b=m4Poc8sLczXV2WmM7yYlVTzAFvd6HJX9G2oM8Wr17/wn52DS7bEn++ERhv+pR2TSmYWu
 OqWVlyprnHfT2HiCaukSj6ceb67rTDIm1jQntL5lYy3SiCTClvirV/B9d+suBlNCDawe
 brKp20QqjGQFRL1pQvOt6eqhQsoVPW7xVdLhTTHC3js/tO/QdjJWXvErH9uRGX2q/YWm
 ZbsLTIyqbD4tijdcZaei7e6QFnvFFg9W7EwGMliBMo2A7PJ1KUehpEV/uOdJS+HKVEgU
 8sm/rA7y0bksYMvsR2EqKspo9poN8/YlpSeJaB6eMrkNT3BP2FDO7stU8eKEfdCpZlxB KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3367sytxbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 04:25:25 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07R82BrE121533;
        Thu, 27 Aug 2020 04:25:24 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3367sytxaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 04:25:24 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R8NKw2012423;
        Thu, 27 Aug 2020 08:25:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 332utq3b18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 08:25:22 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R8PKCa29425926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 08:25:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 916A9AE04D;
        Thu, 27 Aug 2020 08:25:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B132AE045;
        Thu, 27 Aug 2020 08:25:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.43.157])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 08:25:19 +0000 (GMT)
Subject: Re: Getting WIP aops branch(ovl-aops-wip) in shape for merging.
To:     cgxu519@mykernel.net, Amir Goldstein <amir73il@gmail.com>
Cc:     miklos <miklos@szeredi.hu>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        linux-unionfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
References: <20200313140843.5C65542045@d06av24.portsmouth.uk.ibm.com>
 <CAOQ4uxgabS0GMaMXHbhXoBv9OXAZv9O2WzZ-h9aWhZm6quASOg@mail.gmail.com>
 <20200812140012.875A711C089@d06av25.portsmouth.uk.ibm.com>
 <CAOQ4uxhf6R2Gr1wV_LGbAuDGuuPmnb0Mvx43MxWc2O1gQkrGUQ@mail.gmail.com>
 <20200812170001.50BA6A4067@b06wcsmtp001.portsmouth.uk.ibm.com>
 <CAOQ4uxj7JzmKdrV5Z2AHFFk09OwJL_djjE=JOxVOxQU8HVFkVg@mail.gmail.com>
 <20200826142714.2CA0FAE067@d06av26.portsmouth.uk.ibm.com>
 <CAOQ4uxjCPQF4LxE4kmMuOf3sa7Xrkcm-ZvdjBBtKgNWjY7Qb6g@mail.gmail.com>
 <20200827073647.66DEC52051@d06av21.portsmouth.uk.ibm.com>
 <1742eff988b.f97421f5734.6795211467293709335@mykernel.net>
From:   Ritesh Harjani <riteshh@linux.ibm.com>
Date:   Thu, 27 Aug 2020 13:55:18 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1742eff988b.f97421f5734.6795211467293709335@mykernel.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Message-Id: <20200827082519.5B132AE045@d06av26.portsmouth.uk.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_02:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 malwarescore=0 clxscore=1015 adultscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270057
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 8/27/20 1:48 PM, Chengguang Xu wrote:
> 
> ---- On 星期四, 2020-08-27 15:36:46 Ritesh 
> Harjani<riteshh@linux.ibm.com> wrote ----
> 
> 
> 
>     On 8/27/20 12:12 PM, Amir Goldstein wrote:
>      > On Wed, Aug 26, 2020 at 5:27 PM Ritesh Harjani
>     <riteshh@linux.ibm.com <mailto:riteshh@linux.ibm.com>> wrote:
>      >>
>      >> Hello Amir,
>      >>
>      >> On 8/12/20 10:44 PM, Amir Goldstein wrote:
>      >>>> Sure. So here is what I was planning.
>      >>>> I am about to start going over patches mentioned in Amir's
>     ovl-aops-wip
>      >>>> branch. My first preference would be to port it to latest
>     upstream and
>      >>>> start cleaning it up.
>      >>>> I will update the branch details once those patches are ported to
>      >>>> latest upstream. Let me know if we should do this in any
>     different way.
>      >>>>
>      >>>
>      >>> Sounds like a plan.
>      >>>
>      >>>> I will also be joining this year's plumber, in case if we want
>      >>>> to discuss anything on this. Although I am not sure if by
>     then, I would
>      >>>> be able to get any substantial work done to discuss with a wider
>      >>>> audience. But nevertheless, we can always have a call/email
>     exchanges
>      >>>> for this, both before and after the conference :)
>      >>>>
>      >>>
>      >>> Nice. I will be giving a talk on new overlayfs features on the
>     containers track.
>      >>> I guess there won't be much in the hallway tracks this year...
>      >>
>      >>
>      >> I went over almost all patches which you have in ovl-aops-wip
>     branch.
>      >> For now I have only ported some of the straight forward patches,
>      >> since I had few queries on those other patches and one was mainly
>      >> w.r.t. metadata only feature functionality.
>      >>
>      >
>      > Those questions you can also ask Vivek if you find him in LPC...
> 
>     Sure, thanks. Will try to check with Vivek.
> 
>      >
>      >> Do you have sometime today to discuss about it in any of the LPC
>     hacker
>      >> room? I was thinking maybe discussing this in person will help a
>     lot.
>      >>
>      >
>      > I agree that a video meetup can be useful to kickoff this effort,
>     but
>      > it is preferred if Chengguang can also attend, because it feels like
>      > you guys need to collaborate.
>      >
>      >> Any preferred slot? I could not find you online on LPC chat area,
>      >> we can as well discuss the slot there. But I am fine with any of
>     the LPC
>      >> timings.
>      >>
>      >
>      > I cannot do LPC times today or tomorrow, but the hacker rooms are
>      > open and judging by the time of your email you may be closer to my
>      > time zone, so if you want to schedule a meeting somewhere in the
>     next
>      > 5 hours, I can join. (7:00-12:00 UTC).
>      >
>      > Otherwise, we can always schedule a call outside of LPC, where
>      > participants not registered to LPC will be able to join
>     (Chengguang?).
>      >
> 
>     I agree. Yes, 7:00 - 12:00 UTC works for me.
> 
>     @Chengguang,
>     Could you please tell if 7:00 - 12:00 UTC works for you? If yes, then
>     shall we meet once to discuss about aops implementation for overlayfs.
>     Is today 11:am UTC ok with you? If yes, then shall we meet today using
>     below link?
> 
>     https://meet.google.com/txn-hbjg-zgx
> 
>     11:am UTC is fine for me，I’ll be there if there’s nothing special.


Ok, gr8. Then let's meet at 11:am UTC timing on the same google meetup link
https://meet.google.com/txn-hbjg-zgx

-ritesh

