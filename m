From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V2] Consistent d_ino test for non-samefs setup
Date: Mon, 9 Oct 2017 08:45:43 +0300
Message-ID: <CAOQ4uxjg7pq66xyOotNeTUYTpourRHpLTmK1nQN7DWxN96Fh8A@mail.gmail.com>
References: <20171008112558.19061-1-chandan@linux.vnet.ibm.com> <20171008214002.GT15067@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36259 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdJIFpo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Oct 2017 01:45:44 -0400
In-Reply-To: <20171008214002.GT15067@dastard>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Mon, Oct 9, 2017 at 12:40 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Oct 08, 2017 at 04:55:58PM +0530, Chandan Rajendra wrote:
>> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>
> Can you please describe the test, what bug it's addressing, what a
> "non-samefs" configuration is, etc in the commit message?
>

Chandan I suggest that you include the elaborate description
That was part of 038 commit message in both test descriptions.

To be clear, please State the goal of this test is to verify that
Inode numbers returned by readdir d_ino are consistent with
Inode numbers returned by stat st_ino in all the listed cases.

> I've got absolutely no clue what this test is actually trying to
> exercise, and I doubt anyone not intimately familiar with overlay
> has any idea, either...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
