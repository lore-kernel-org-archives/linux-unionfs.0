Return-Path: <SRS0=do5T=BW=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A865C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 17:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31CD320774
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 17:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="da8Cfyo+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHLRAZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 13:00:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbgHLRAX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Aug 2020 13:00:23 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07CGYlcN134087;
        Wed, 12 Aug 2020 13:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : date : mime-version : in-reply-to : content-type :
 content-transfer-encoding : message-id; s=pp1;
 bh=C2NidouqxZDMrrlRYR2dtusE4rYEDPL9wWBiPbRKDJo=;
 b=da8Cfyo+SE7UI5d6/RXYcQSjlZgFqbSfjc42/hv52Gc6Wsl/Pzg6e42haS92RnAbfQvW
 Ve1aYGxXnd9dyw8+7ThFTOFKQ4waI1s1F/xLTpX6aL7he1bs4uUZ6MDgbN1vRq9XmyA8
 0tRXFgmQYGIiZycNUGIUQN6DkOUdCQXqU10KjNPlXOFwkhzxxnvWDdeg7+2PW3ZmQ8wG
 mnFaIbjABal5ynJkg7YyD5ijiRxyTIsvorXy+O2uD3YToAqUhCWWDouCOBB02QXclDRL
 qdoD9JQpvkTH7H4kT6utW+NGFSFG56tvePw1GxwaUPErAyEHsaTl6VzGuTxQYPdA4z17 eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32utn95at2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 13:00:07 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07CGvq1A002825;
        Wed, 12 Aug 2020 13:00:07 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32utn95ara-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 13:00:07 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07CGxPts011437;
        Wed, 12 Aug 2020 17:00:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 32skp7tv50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 17:00:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07CH02Nd19988986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 17:00:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 602EFA405C;
        Wed, 12 Aug 2020 17:00:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50BA6A4067;
        Wed, 12 Aug 2020 17:00:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.33.217])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Aug 2020 17:00:01 +0000 (GMT)
Subject: Re: Getting WIP aops branch(ovl-aops-wip) in shape for merging.
To:     Amir Goldstein <amir73il@gmail.com>,
        Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
References: <20200313140843.5C65542045@d06av24.portsmouth.uk.ibm.com>
 <CAOQ4uxgabS0GMaMXHbhXoBv9OXAZv9O2WzZ-h9aWhZm6quASOg@mail.gmail.com>
 <20200812140012.875A711C089@d06av25.portsmouth.uk.ibm.com>
 <CAOQ4uxhf6R2Gr1wV_LGbAuDGuuPmnb0Mvx43MxWc2O1gQkrGUQ@mail.gmail.com>
From:   Ritesh Harjani <riteshh@linux.ibm.com>
Date:   Wed, 12 Aug 2020 22:30:00 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhf6R2Gr1wV_LGbAuDGuuPmnb0Mvx43MxWc2O1gQkrGUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Message-Id: <20200812170001.50BA6A4067@b06wcsmtp001.portsmouth.uk.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_12:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120110
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 8/12/20 9:31 PM, Amir Goldstein wrote:
> On Wed, Aug 12, 2020 at 5:00 PM Ritesh Harjani <riteshh@linux.ibm.com> wrote:
>>
>> Hello Amir / Miklos
> 
> Hi Ritesh,
> 
> Those are good questions.
> If you don't mind, please reply with the overlayfs list in CC, so
> that others could benefit from my answers.

Done & thanks for your answers. :)


> 
> I took the liberty to CC Chengguang Xu, who may be interested in this as well.
> 
>>
>> Sorry for getting late on this. I was pulled into some other work
>> before, so I couldn't get to this earlier.
>> I have resumed this work now and and for starters I am going through
>> some key overlayfs functions and data structures (since it has
>> changed since I last checked - more than a year back). I guess more
>> upcoming use cases in containers is the reason for lot of active
>> development in overlayfs :)
>>
>>
>> - While going through ovl_copy_up_tmpfile(), I had this query on
>> why are we setting "temp" dentry as the __upperdentry of ovl_inode?
>> "ovl_inode_update(d_inode(c->dentry), temp);"
>> And similarly in ovl_copy_up_workdir()
> 
> For two different reasons:
> In ovl_copy_up_workdir() d_move() moves 'temp' dentry onto 'upper'.
> In ovl_copy_up_tmpfile() we could use either 'temp' or 'upper'.
> I don't think there was a specific reason for choosing 'temp' beyond the
> fact that before:
> b10cdcdc2012 ovl: untangle copy up call chain
> There was more code in common between these two functions.
> 
> The reason that we could use either  'temp' or 'upper' is because nothing
> AFAIK reads d_parent and d_name of __upperdentry of a non-directory inode
> and the values of those dentry members would be arbitrary anyway with a
> hardlinked/indexed inode.

I agree. I was curious that the above mentioned commit specifically
changed it from "upper" to "temp". While we could have used "upper" as
well.


> 
>>
>> Shouldn't we set "upper" dentry as __upperdentry and do d_put on temp.
>> Although even with current code, I don't see a bug in the functionality,
>> but I was wondering why was this change done in below commit.
>>
>> commit: 6b52243f633eb552 (ovl: fold copy-up helpers into callers)
>>
>> Am I missing anything? Shouldn't the obvious thing to do was to make the
>> "upper" as the upperdentry in ovl_inode?
>>
>>
>> - I did take a brief look at your commits as well in that ovl-aops-wip
>> branch. IIUC, below is a brief summary of what we are trying to solve
>> with aops implementation.
>>
>> Currently if we have a r/o MAP_SHARED file mmaped on the lowerlayer. And
>> if some other process changes the underlying file contents of this file,
>> the process which had r/o mmaped is not able to see those modified
>> changes. This behavior is not valid as per POSIX standard.
>> And the problem really happens because in overlayfs if a lower layer
>> inode is opened for write, it will usually create another inode
>> in the upper layer, will copy_up and will write the changes to new
>> inode. Now since these are two different inodes (which could even be
>> residing in different FS), hence the MAP_SHARED inconsistency problem.
>>
>> Solution - what you proposed it to implement aops for overlayfs
>> which should *(also)* help in solving above MAP_SHARED inconsistency
>> problem.
> 
> More or less. yes. I can't even remember the fine details anymore,
> but IIRC, MAP_SHARED and upper inodes would always use the overlay inode
> pages, while MAP_PRIVATE would use the real inode pages for non-upper inodes,
> in order to share pages among containers with the same lower layers.
> Some more optimizations may be possible going forward for sharing more pages.
> 
>>
>> - I guess once I start going through your patches in more detail,
>> I may approach you for any other query :)
>> Does overlayfs has any IRC channel as well?
> 
> Not that I know of.
> 
>> Or is it mostly through emails?
>>
> 
> Mostly emails.

Sure.

> 
> One thing to note is that the syncfs work [1] by Chengguang Xu will be
> made redundant
> by overlayfs aops.

ohk.


> 
> I don't know if he is planning to follow up on his work. It is not so
> fair to blocks it until
> aops is completed which may take time or take forever, but you may

Sure, agreed.

> want to talk to
> him about collaborating on implementing the aops solution.

Sure. So here is what I was planning.
I am about to start going over patches mentioned in Amir's ovl-aops-wip
branch. My first preference would be to port it to latest upstream and
start cleaning it up.
I will update the branch details once those patches are ported to
latest upstream. Let me know if we should do this in any different way.

I will also be joining this year's plumber, in case if we want
to discuss anything on this. Although I am not sure if by then, I would
be able to get any substantial work done to discuss with a wider
audience. But nevertheless, we can always have a call/email exchanges
for this, both before and after the conference :)

> Looks like he already has a lot of experience with inode writeback and
> overlayfs.

That's really nice!!

-ritesh
