From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [xfstests PATCH v2 2/4] overlay: add fsck.overlay whiteout test
Date: Wed, 7 Feb 2018 12:13:37 +0800
Message-ID: <d3a2d30c-88da-b9f9-4645-3f57926faec8@huawei.com>
References: <20180131102604.40701-1-yi.zhang@huawei.com>
 <20180131102604.40701-3-yi.zhang@huawei.com>
 <20180206042238.GO18267@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:5184 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752682AbeBGEPf (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Feb 2018 23:15:35 -0500
In-Reply-To: <20180206042238.GO18267@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com, yangerkun@huawei.com

On 2018/2/6 12:22, Eryu Guan Wrote:
> On Wed, Jan 31, 2018 at 06:26:02PM +0800, zhangyi (F) wrote:
>> Add fsck.overlay test case to test it how to deal with orphan/valid
>> whiteouts in underlying directories of overlayfs.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> So sorry for the late review! All four patches look fine to me overall,
> just some minor issues inline.
> 

Thanks for your comments, I will handle them soon.

Thanks,
Yi.
