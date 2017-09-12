From: Jordi Pujol Palomer <jordipujolp@gmail.com>
Subject: Re: v4.13 overlay fs: sometimes fails when creating or moving files
Date: Tue, 12 Sep 2017 11:18:47 +0200
Message-ID: <20170912111847.72399aef@localdomain>
References: <20170908143704.3c74d20f@localdomain>
        <CAOQ4uxjC+ONu9nj-BJ8XwuWU0ofq5ySd-YRmXdikQjPAXj3WuA@mail.gmail.com>
        <CACTE=goi1H-rEKA4_2iZTsaW9k9k+kMCgnzWcZJBt4+-M93pmg@mail.gmail.com>
        <CAOQ4uxhKy1uWarTyAQqXmvk5nPsLYEsb1zgfSaSv-mcxby0+6g@mail.gmail.com>
        <CACTE=gp1JRmVtY_SR4YRx5CsPPFrrPsgbxq=JYH_VYRq8rQZsw@mail.gmail.com>
        <CAOQ4uxjEMJUGesER22p_wE2THejhNCobdcyOEZb5YffR9uKD2w@mail.gmail.com>
        <CAOQ4uxjHsukvK77OpJWA=noYMW4AVVWdVyHEYL8KGRGFV1H1Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38587 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdILJSw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2017 05:18:52 -0400
Received: by mail-wr0-f195.google.com with SMTP id p37so5607116wrb.5
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2017 02:18:52 -0700 (PDT)
In-Reply-To: <CAOQ4uxjHsukvK77OpJWA=noYMW4AVVWdVyHEYL8KGRGFV1H1Kw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, 11 Sep 2017 15:19:44 +0300
Amir Goldstein <amir73il@gmail.com> wrote:

> You are welcome to try this fix if problem is reproducing for you
> or verify the simpler hardlink regression.

I have tried it in varied scenarios, a Live system with persistence
and a chroot to an image filesystem.
In all cases overlayfs performs well without that related errors.

Thanks,

Jordi Pujol i Palomer
