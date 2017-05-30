From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ovl_dir_read_merged: Redundant call to list_add()
Date: Tue, 30 May 2017 11:05:55 +0300
Message-ID: <CAOQ4uxhQD_PecXQFLM+7j0wMY9y51NPcw_iOR0gZn9-RZBieOQ@mail.gmail.com>
References: <1982032.d2FfUCRVGU@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35059 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdE3IF4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 May 2017 04:05:56 -0400
Received: by mail-oi0-f48.google.com with SMTP id l18so102008613oig.2
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2017 01:05:56 -0700 (PDT)
In-Reply-To: <1982032.d2FfUCRVGU@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, May 30, 2017 at 9:39 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> ovl_dir_read_merged() has the following loop,
>
>         for (idx = 0; idx != -1; idx = next) {
>                 next = ovl_path_next(idx, dentry, &realpath);
>
>                 if (next != -1) {
>                         err = ovl_dir_read(&realpath, &rdd);
>                         if (err)
>                                 break;
>                 } else {
>                         /*
>                          * Insert lowest layer entries before upper ones, this
>                          * allows offsets to be reasonably constant
>                          */
>                         list_add(&rdd.middle, rdd.list);
>                         rdd.is_lowest = true;
>                         err = ovl_dir_read(&realpath, &rdd);
>                         list_del(&rdd.middle);
>                 }
>         }
>
>
> rdd.middle is populated inside ovl_fill_lowest() which is indirectly invoked
> by the call to ovl_dir_read() inside the "else" part of the above "if"
> condition. Before this invocation of ovl_dir_read(), rdd.middle would
> basically be an empty list. So this would mean that the call
> list_add(&rdd.middle, rdd.list) is unnecessary.
>
> Please let me know if I am missing something here.
>

You are missing the fact that rdd.middle is not a new list.
its a list element inserted into the circular list rdd.list as a marker
to the head of the non-lowest entries list.
When referencing &rdd.middle inside ovl_fill_lowest() code
is referencing the same list that was populated in rdd.list,
but with a different head/tail.
