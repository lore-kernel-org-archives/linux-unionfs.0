From: Jordi Pujol Palomer <jordipujolp@gmail.com>
Subject: Re: v4.13 overlay fs: sometimes fails when creating or moving files
Date: Fri, 8 Sep 2017 17:22:56 +0200
Message-ID: <20170908172256.563e1e8d@localdomain>
References: <20170908143704.3c74d20f@localdomain>
        <CAOQ4uxjC+ONu9nj-BJ8XwuWU0ofq5ySd-YRmXdikQjPAXj3WuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35562 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756290AbdIHPXC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Sep 2017 11:23:02 -0400
Received: by mail-wr0-f194.google.com with SMTP id n64so1393725wrb.2
        for <linux-unionfs@vger.kernel.org>; Fri, 08 Sep 2017 08:23:02 -0700 (PDT)
In-Reply-To: <CAOQ4uxjC+ONu9nj-BJ8XwuWU0ofq5ySd-YRmXdikQjPAXj3WuA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, 8 Sep 2017 17:20:50 +0300
Amir Goldstein <amir73il@gmail.com> wrote:

> This sounds a lot like
> https://bugzilla.redhat.com/show_bug.cgi?id=1213602 A long standing
> issue with a simple workaround (see link above)
> 
the problem also arises when executing 
touch /var/lib/dpkg/*
before upgrading,
maybe the issue is not the same,

> Is the problem you are hitting new to v4.13?
Yes, this problem is new,
therefore my computer continues running 4.12.11 by now.

Thanks,

Jordi Pujol i Palomer
