From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH V2] ovl:fix rmdir problem on impure dir
Date: Mon, 19 Jun 2017 19:19:42 +0800
Message-ID: <14574573-a05e-8045-93d4-e27ec5430c14@huawei.com>
References: <1497844832-24767-1-git-send-email-yi.zhang@huawei.com>
 <CAJfpegvMjzLuP5YaTXaXTmVeFW7xEMRNOk_5nUoaSR=zRtS9MA@mail.gmail.com>
 <CAOQ4uximW7=COjJPvLbCmE93UZ-ZYNdkEuFji-xXwHfSkjqqaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:8755 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753711AbdFSLUi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 07:20:38 -0400
In-Reply-To: <CAOQ4uximW7=COjJPvLbCmE93UZ-ZYNdkEuFji-xXwHfSkjqqaw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, miaoxie@huawei.com

On 2017/6/19 16:28, Amir Goldstein wrote:
> On Mon, Jun 19, 2017 at 10:59 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, Jun 19, 2017 at 6:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>
>> I still don't like adding the impure flag because of a whiteout.
>> Impure dir means it contains a copied up object.  In fact a valid (but
>> probably not worthwhile) optimizition would be to remove the impure
>> flag on removal of the last copied up object.
>>
>> What's wrong with testing for (origin || merge) to see if we need to
>> check for whiteouts?
>>
> 
> Fine by me.
> 
> Yi,
> 
> Please note that you cannot use the test OVL_TYPE_ORIGIN(type)
> in ovl_dir_is_real(), because that flag is only set when the lower
> dentry is found by lookup. Instead, you should explicitly check for
> existence of OVL_XATTR_ORIGIN.
> Note that even ovl_get_origin_fh() is too strict, because it discards
> empty (unkown) origin, but for your use case, unknown origin is also
> candidate to contain whiteouts.
> 

I realize that impure flag is not quite suitable. If we use (origin || merge)
to see whether we need to check whiteouts or not, I think we still have a
problem.

Thought: In my current test case, testdir was copyuped when we delete
the test file, so it have OVL_XATTR_ORIGIN (it's OK), but if the testdir
is a merged dir originally, it will not be copied up and the OVL_XATTR_ORIGIN
will not be set.

So, if we want to use (origin || merge), we have to set OVL_XATTR_ORIGIN for
the merged parent dir when it create whiteout, any side effects?

Thanks,
ZhangYi.
