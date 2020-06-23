Return-Path: <SRS0=DVGR=AE=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB632C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 23 Jun 2020 17:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A756F20781
	for <linux-unionfs@archiver.kernel.org>; Tue, 23 Jun 2020 17:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592932575;
	bh=zIFMUdRtrDfrUjfIdnOYBBIbHPhs1Vg38taEV1Fq9eM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ntcjksD1rvItK/hhSO9+9ByQjv/El1VxqtvXnZmfNCZhg2lBQ06WxmtpXELiGRy9S
	 C4sBYF/Ub2cmu7L5IkhuhfRV4eRP1SG7zXvFcAIrPDgOV+DzRcECv2Xyul9rSi+ZD5
	 praJHPw8NFA0wfquvNbs6lMo5F1w+6HIrQmT9uVw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732648AbgFWRQP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 13:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732565AbgFWRQP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 Jun 2020 13:16:15 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5655720780;
        Tue, 23 Jun 2020 17:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592932574;
        bh=zIFMUdRtrDfrUjfIdnOYBBIbHPhs1Vg38taEV1Fq9eM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SecGrRkG/Ps5OBToybDUH6vdXzzo7ec+Uka790MxbylSYhFK3e1AJGxv1J9PvLY6J
         aGmj2p2wQByUQN/bHB2rxunDDKKi/a6fKfHp9RhdgGeoAqXz2VCrSJ8AhF8TyaV8dH
         1TWh9xsRPzalXKSS7tVZQdAhU89iLCGY2nCPfKBM=
Date:   Tue, 23 Jun 2020 13:16:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-unionfs@vger.kernel.org, lkft-triage@lists.linaro.org
Subject: Re: [PATCH AUTOSEL 4.14 090/108] ovl: verify permissions in
 ovl_path_open()
Message-ID: <20200623171613.GB1931@sasha-vm>
References: <20200618012600.608744-1-sashal@kernel.org>
 <20200618012600.608744-90-sashal@kernel.org>
 <CA+G9fYuBGRz9=Q5KyCat0qk_8aiGvNsreY05rcGSjMZpvM1FJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+G9fYuBGRz9=Q5KyCat0qk_8aiGvNsreY05rcGSjMZpvM1FJg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 23, 2020 at 08:55:38PM +0530, Naresh Kamboju wrote:
>On Thu, 18 Jun 2020 at 07:18, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Miklos Szeredi <mszeredi@redhat.com>
>>
>> [ Upstream commit 56230d956739b9cb1cbde439d76227d77979a04d ]
>>
>> Check permission before opening a real file.
>>
>> ovl_path_open() is used by readdir and copy-up routines.
>>
>> ovl_permission() theoretically already checked copy up permissions, but it
>> doesn't hurt to re-do these checks during the actual copy-up.
>>
>> For directory reading ovl_permission() only checks access to topmost
>> underlying layer.  Readdir on a merged directory accesses layers below the
>> topmost one as well.  Permission wasn't checked for these layers.
>>
>> Note: modifying ovl_permission() to perform this check would be far more
>> complex and hence more bug prone.  The result is less precise permissions
>> returned in access(2).  If this turns out to be an issue, we can revisit
>> this bug.
>>
>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  fs/overlayfs/util.c | 27 ++++++++++++++++++++++++++-
>>  1 file changed, 26 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
>> index afdc2533ce74..76d6610767f6 100644
>> --- a/fs/overlayfs/util.c
>> +++ b/fs/overlayfs/util.c
>> @@ -307,7 +307,32 @@ bool ovl_is_whiteout(struct dentry *dentry)
>>
>>  struct file *ovl_path_open(struct path *path, int flags)
>>  {
>> -       return dentry_open(path, flags | O_NOATIME, current_cred());
>> +       struct inode *inode = d_inode(path->dentry);
>> +       int err, acc_mode;
>> +
>> +       if (flags & ~(O_ACCMODE | O_LARGEFILE))
>> +               BUG();
>> +
>> +       switch (flags & O_ACCMODE) {
>> +       case O_RDONLY:
>> +               acc_mode = MAY_READ;
>> +               break;
>> +       case O_WRONLY:
>> +               acc_mode = MAY_WRITE;
>> +               break;
>> +       default:
>> +               BUG();
>
>This BUG: triggered on stable-rc 5.7, 5.4, 4.19 and 4.14.
>
>steps to reproduce:
>          - cd /opt/ltp
>          - ./runltp -s execveat03

Yup, that patch has been dropped, thanks for testing!

-- 
Thanks,
Sasha
