From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/2] overlay/038: test consistent values of st_ino/d_ino
 for subdirs
Date: Tue, 21 Nov 2017 08:30:29 +0200
Message-ID: <CAOQ4uxjKdwKHLrOXh2uJgmvY9-YnNRDBA=BqQfpQeueQiDR7qA@mail.gmail.com>
References: <20171120143410.23357-1-chandan@linux.vnet.ibm.com> <20171120143410.23357-2-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:44608 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753069AbdKUGaa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Nov 2017 01:30:30 -0500
In-Reply-To: <20171120143410.23357-2-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Mon, Nov 20, 2017 at 4:34 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit implements similar changes made to overlay/038 test i.e. in
> addition to checking consistent values of st_ino/d_ino for "."  and ".."
> entries, check also the values for subdir inside each tested directory
> setup.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Lokks good and tested.

Thanks,
Amir.
