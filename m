From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [xfstest PATCH] overlay/031: add tests of whiteouts in lowerdir
 and both dirs
Date: Thu, 29 Jun 2017 21:18:33 +0800
Message-ID: <4091c94e-7858-8f52-5a11-5dd1eeaf60d0@huawei.com>
References: <1498644722-43912-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxipk=T_+mCzpkDS8xGnhnYkO1jqbbG5Mho8bk4He2nL8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:9251 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752684AbdF2NSo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Jun 2017 09:18:44 -0400
In-Reply-To: <CAOQ4uxipk=T_+mCzpkDS8xGnhnYkO1jqbbG5Mho8bk4He2nL8w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On 2017/6/28 18:49, Amir Goldstein wrote:
> On Wed, Jun 28, 2017 at 1:12 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> In overlay/031, it only cover the test case of whiteouts in
>> origined upper dir. This patch add two cases cover the other
>> two situations:
>>
>> 1) Lower origined dir have whiteouts;
>> 2) Both upper and lower origined dirs have whiteouts (although
>> this case is pass now, still add this to cover all three kinds
>> of situations).
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> 
> Great work.
> Some minor comments...

Thanks for your comments. I will fix them and test base on overlayfs-devel.

Thanks,
ZhangYi.
