From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs fix for 4.8-rc5
Date: Fri, 9 Sep 2016 12:58:50 -0700
Message-ID: <CA+55aFxX-UbDjL8R1beqP_ZE6-eXJMgnuvPZmJQxA9n-3srEQQ@mail.gmail.com>
References: <20160909193709.GO25404@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160909193709.GO25404@veci.piliscsaba.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Sep 9, 2016 at 12:37 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> This fixes a regression caused by the last pull request.

So why are you checking error numbers one by one?

Why is an error not just always an error?

              Linus
