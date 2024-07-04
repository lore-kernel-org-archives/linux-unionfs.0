Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEF91A2FBD
	for <linux-unionfs@vger.kernel.org>; Thu,  4 Jul 2024 07:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720077935; cv=none; b=jLY5rLDFZFeaz+8JZv5T62i6h7hiVpQvAtvTgl8lT8Ok+j0RPMlPVhAbSMxYnyFjqu0aRwRcIvceYRnbEtJ4BMNjiw2jD4rHApHNG8FuGRb1eIngtqL9QHmzmvM76Ll8I/5abEBQ6+PJJYzaAfAfvZ25pGpt6K225qTQgYxdZZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720077935; c=relaxed/simple;
	bh=dXwrnEm3zP6/MkLC9gI9D3jR1YBIkXrFMTgglLawx5Q=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=uUSfHAnqJLeJIL2u9s8pgBWZ8Y9uXNCPl08VZfelpIFAsf68ng/UfpTSTPFg3ENfHPDSf+ZyxB1v5kEOTdVLu+j+IT57XqAMlZqWcaBjc3GYGuXp4VDLKLQhhmZ2zuv5x5zofnHV6FtSp0iSyNxPs6nz8ibUnFJPlFvIQ5v2Sms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WF7NL13WdzZhPj;
	Thu,  4 Jul 2024 15:20:50 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id BB2E6140157;
	Thu,  4 Jul 2024 15:25:24 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemm000013.china.huawei.com (7.193.23.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 4 Jul 2024 15:25:24 +0800
Subject: Re: [PATCH] ovl: fix wrong lowerdir number check for parameter
 Opt_lowerdir
To: Amir Goldstein <amir73il@gmail.com>, Christian Brauner
	<brauner@kernel.org>
CC: <miklos@szeredi.hu>, <linux-unionfs@vger.kernel.org>
References: <20240703044631.4089465-1-chengzhihao1@huawei.com>
 <CAOQ4uxg8YvWYobbx5ztjkw6ZnUVgv1JDWFYq71HQ5O22=jYTKw@mail.gmail.com>
 <20240703-maulwurf-beinverletzungen-dfb0ff663d78@brauner>
 <CAOQ4uxjhc2f2D68emH7mdBBa4Cut7R7AjRASkDS9GQtr3MPEHQ@mail.gmail.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <97933464-378c-7158-141d-4b912254f6aa@huawei.com>
Date: Thu, 4 Jul 2024 15:25:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjhc2f2D68emH7mdBBa4Cut7R7AjRASkDS9GQtr3MPEHQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm000013.china.huawei.com (7.193.23.81)

在 2024/7/3 23:18, Amir Goldstein 写道:
> On Wed, Jul 3, 2024 at 4:48 PM Christian Brauner <brauner@kernel.org> wrote:
>>
[...]
>>>
>>> This fix looks correct, but it is not pretty IMO.
>>> The cleanup on error is much cleaner in ovl_parse_layer() -> ovl_add_layer()
>>> I wonder if we can reuse some of those helpers instead of the current code.
>>>
>>> Christian, what do you think?
>>
>> Yeah, sounds good. Something like the completely untested below.
>> Feel free to reuse in whatever form.

Thanks Christian, it's so nice of you.
> 
> This looks much nicer!
> I think you unintentionally dropped incrementing of ctx->nr_data
> for the notorious case of ::<lowerdatadir>.

Hi, Amir, thanks for reminding, I modify some points based on the 
patches from Christian:
1. Use ovl_mount_dir() to parse parameter string for Opt_lowerdir, 
because I found the character '\' can be filtered from parameter string 
for Opt_lowerdir, so I want to keep it(Not sure whether it's right).

mount("none", "/root/tmp/merge", "overlay", 0, "lowerdir=low\\er:lower2")
2. Keep 'ctx->nr_data' updating in ovl_parse_param_lowerdir(). I was 
going to move 'ctx->nr_data' updating into ovl_add_layer() by passing 
'Opt_datadir_add' into ovl_parse_layer(), but I found 
ovl_mount_dir_check() use this opt to do some check, the opt should be 
Opt_lowerdir.
3. Remove 'out_put' error handling branch from 
ovl_parse_param_lowerdir(), because ovl_fs_context_free is invoked if 
something error happens.
> 
> Zhihao,
> 
> Please make sure to run the fstests overlay test for lowerdatadirs
> overlay/079 overlay/085 overlay/086

BTW, I get overlay/061 failed even before applying my patches. Maybe I 
will take some time to analyze it.

overlay/061       - output mismatch (see 
/root/git/xfstests-dev/results//overlay/061.out.bad)
     --- tests/overlay/061.out	2023-04-01 14:14:58.354052795 +0800
     +++ /root/git/xfstests-dev/results//overlay/061.out.bad	2024-07-04 
14:52:44.993000000 +0800
     @@ -1,4 +1,4 @@
      QA output created by 061
     -00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 
aaaaaaaaaaaaaaaa
     +00000000:  54 68 69 73 20 69 73 20 6f 6c 64 20 6e 65 77 73 
This.is.old.news
      After mount cycle:
      00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 
aaaaaaaaaaaaaaaa
     ...
     (Run 'diff -u /root/git/xfstests-dev/tests/overlay/061.out 
/root/git/xfstests-dev/results//overlay/061.out.bad'  to see the entire 
diff)

v2 pacthes: 
https://lore.kernel.org/linux-unionfs/20240704070323.3365042-1-chengzhihao1@huawei.com/T/#mdaedba39d7f261cd2555ea6773ed3611c02e7a4e

