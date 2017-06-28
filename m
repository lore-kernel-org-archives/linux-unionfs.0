From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [xfstest PATCH v2] overlay: test whiteout check in origin dir
Date: Wed, 28 Jun 2017 17:11:52 +0800
Message-ID: <93945f89-fd39-ff26-de5d-fc9a80897eef@huawei.com>
References: <1498637045-19185-1-git-send-email-yi.zhang@huawei.com>
 <20170628084559.GG23360@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:9246 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbdF1JMM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Jun 2017 05:12:12 -0400
In-Reply-To: <20170628084559.GG23360@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com

On 2017/6/28 16:45, Eryu Guan Wrote:
> On Wed, Jun 28, 2017 at 04:04:05PM +0800, zhangyi (F) wrote:
>> The unmerged and origined directories may contain invalid
>> whiteouts when we umount && modify dir(e.g. clean up dir) and
>> remount overlay. This may lead to whiteouts exposure and rmdir
>> failure.
>>
>> This case test origin dir's whiteouts check in ovl_iterate() and
>> ovl_remove_xxx().
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>> v2:
>>  - add test of lower origin dir have whiteouts
>>  - add test of both upper and lower origin dirs have whiteouts
>>    (although this case is pass now, still add this to cover all
>>    three kinds of situations)
>>  - add to whiteout group
> 
> Thanks for the updated patch! But I've already pushed your v1 patch out
> to upstream, could you please send another patch to update the existing
> overlay/031 test?
> 

Sorry, I didn't known you've pushed it. I will resend this update patch.

Thanks,
ZhangYi.
