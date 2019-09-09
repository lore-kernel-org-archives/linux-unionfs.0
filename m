From: rishabhb@codeaurora.org
Subject: Re: Bug at kernel/cred.c +443
Date: Mon, 09 Sep 2019 15:49:19 -0700
Message-ID: <7e14f9c6fa089da67ebc28d7048c369a@codeaurora.org>
References: <083b3f61efeca1d73839ac96e396748e@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <083b3f61efeca1d73839ac96e396748e@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tsoni@codeaurora.org, psodagud@codeaurora.org, jshriram@codeaurora.org
List-Id: linux-unionfs@vger.kernel.org

On 2019-09-09 15:47, rishabhb@codeaurora.org wrote:
> Hi Miklos
> 
> In 4.19 kernel when we write to a file that doesn't exist we see the
> following stack:
> [  377.382745]  ovl_create_or_link+0xac/0x710
> [  377.382745]  ovl_create_object+0xb8/0x110
> [  377.382745]  ovl_create+0x34/0x40
> [  377.382745]  path_openat+0xd44/0x15a8
> [  377.382745]  do_filp_open+0x80/0x128
> [  377.382745]  do_sys_open+0x140/0x250
> [  377.382745]  __arm64_sys_openat+0x2c/0x38
> 
> If the override_cred flag = off, the ovl_override_cred and
> ovl_revert_cred just returns NULL.
> But there is another override_cred in between these two functions;
> 		put_cred(override_creds(override_cred));
> 		put_cred(override_cred);
> 
> This will override the credentials permanently as there is no
> corresponding revert_cred associated.
> So whenever we do commit_creds for this task, we see a BUG_ON at
> kernel/cred.c +443.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/cred.c#n443
> 
> Should this override_cred be changed to ovl_override_cred to maintain
> consistency and avoid this
> BUG_ON?
> 
> 
> Thanks,
> Rishabh

Corrected line number in the subject.
