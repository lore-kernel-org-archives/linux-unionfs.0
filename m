From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH V2] ovl:fix rmdir problem on impure dir
Date: Tue, 20 Jun 2017 19:19:35 +0800
Message-ID: <6dfe9455-ed07-d192-3e1e-958a3548a4d2@huawei.com>
References: <1497844832-24767-1-git-send-email-yi.zhang@huawei.com>
 <CAJfpegvMjzLuP5YaTXaXTmVeFW7xEMRNOk_5nUoaSR=zRtS9MA@mail.gmail.com>
 <CAOQ4uximW7=COjJPvLbCmE93UZ-ZYNdkEuFji-xXwHfSkjqqaw@mail.gmail.com>
 <14574573-a05e-8045-93d4-e27ec5430c14@huawei.com>
 <CAJfpegugA+M1sYOpLHKzAQU3qR901Nn3g5MEqSqdNjGLOctStw@mail.gmail.com>
 <CAOQ4uxhm=FLKiFSb3yhTF8gWEPhAGvSF_0tP9hFRotxZ=jiNaQ@mail.gmail.com>
 <6878b23b-af71-cebc-6cfe-3761df6936af@huawei.com>
 <CAOQ4uxhHiCVFkumKsEFzwihBfy-BTC4JxbpB04=HdvQWC_vovA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:8765 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbdFTLUP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2017 07:20:15 -0400
In-Reply-To: <CAOQ4uxhHiCVFkumKsEFzwihBfy-BTC4JxbpB04=HdvQWC_vovA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, miaoxie@huawei.com

on 2017/6/20 15:04, Amir Goldstein wrote:
> On Tue, Jun 20, 2017 at 9:10 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> On 2017/6/19 20:07, Amir Goldstein Wrote:
>>> On Mon, Jun 19, 2017 at 2:44 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Mon, Jun 19, 2017 at 1:19 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>>> On 2017/6/19 16:28, Amir Goldstein wrote:
>>>>>> On Mon, Jun 19, 2017 at 10:59 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>>>> On Mon, Jun 19, 2017 at 6:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> 
> My plans were to defer it to next-next (v4.14) merge cycle along with
> NFS export.
> 
> I suggest that you post a fix to the whiteout problem based on (MERGE
> || ORIGIN),
> disregarding the issue of pre kernel v4.12 upper layers (MERGE && !ORIGIN).
> 

Okay, I will try to use current (MERGE || ORIGIN) to fix, the (MERGE && !ORIGIN)
issue will be fixed automatically after you merge your patchset. Thanks for your
suggestion.

> After my current patch set lands on linux-next, or even after v4.13-rc1, we
> can decide if it is worth while to merge the extra hunk above for the sake of
> fixing whiteout problem with pre v4.12 upper layers.
> 
> Does your use case have to deal with migrating existing upper layers?
> 

I don't have this use case this moment(maybe have in future), it's not urgent.

> BTW, does you use case also care about other types of lower layer changes?
> As part of the work for overlayfs snapshots and NFS export, I also plan to
> post patches to follow renamed lower dir to their new location, instead of
> treating the upper dir as !MERGE, see:
> https://github.com/amir73il/linux/commits/ovl-verify-dir

This case is interesting, I don't have this case too (not so sure), I will
think about this, thanks for reminding.

Thanks,
ZhangYi.
