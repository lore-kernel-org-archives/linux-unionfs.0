Return-Path: <salyzyn@android.com>
Return-Path: <salyzyn@android.com>
Subject: Re: [PATCH v10 5/5] overlayfs: override_creds=off option bypass
 creator_cred
References: <20190724195719.218307-1-salyzyn@android.com>
 <20190724195719.218307-6-salyzyn@android.com>
 <CAOQ4uxim8zZN5YHZs2OJz5A=3B0U10wyf371yadpe2B7hA8pZw@mail.gmail.com>
 <9acceab1-86af-758a-ec00-8f6d33f3da87@android.com>
 <CAOQ4uxhLQGpG0=K46hAgPFgQ3KrDipUCqNs_=L6xNwG-dS_jtw@mail.gmail.com>
From: Mark Salyzyn <salyzyn@android.com>
Message-ID: <82a94a36-773d-3925-7937-e3a4a7129b8b@android.com>
Date: Thu, 25 Jul 2019 09:42:37 -0700
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhLQGpG0=K46hAgPFgQ3KrDipUCqNs_=L6xNwG-dS_jtw@mail.gmail.com>
Content-Type: multipart/alternative;
 boundary="------------55597218440AFED5280F150F"
Content-Language: en-GB
To: Amir Goldstein <amir73il@gmail.com>
Cc: kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

This is a multi-part message in MIME format.
--------------55597218440AFED5280F150F
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/19 9:12 AM, Amir Goldstein wrote:
> [reduce CC list]
>
>>> I am fine with this patch, but would like to request that you add @sb arg
>>> to the ovl_revert_creds() helper, so it is more useful for other things in the
>>> future that scope the underlying layers access (like shutdown).
>> Will respin and retest.
>>
> Apropos testing, I wanted to bring up this issue.
> I noticed that the test coverage I have for unprivileged user access to
> overlayfs is lacking.
>
> xfstests has several generic tests that use _runas and run on overlayfs,
> but that's only for pure upper files.
>
> unionmount-testsuite is always run as root, because it needs to
> mount/umount/etc.
> I am working on a new mode ./run --ov --runas=1
> to seteuid(1);setegid(1) before every test (after set_up and mount)
> That's fine for basic UNIX permission and capability checks, but does not cover
> more complex setups like with sepolicy.
>
> I was thinking maybe to execute "./run --ov --set-up" with mounter process
> credentials (e.g. initd) and then add a new mode "./run --ov --no-set-up"
> which uses the mount prepared by the mounter and runs the tests.
>
> I wanted to get feedback on the ideas above if they are useful for
> your use cases? Is that enough or is there more functionality required
> to cover more use cases?
>
> Thanks,
> Amir.

I had already filed an internal bug to find a solution for this because 
I did not have a full answer to this vacuum in testing. Everything I do 
is cumbersome, manual or instrumented w.r.t. overlayfs with a poor 
velocity because solution is checked on all android kernel releases; and 
relies on a functional device (can be run under emulator) to smoke test 
the integrated result (where we do have some automation).

These new problems that added extra patches to this series were only 
uncovered over the last two months of investigation and root cause on 
4.14 and (very recently) 4.19 devices and have not discovered any 
automation (well, two simple tests is not enough) that pleases me.

We have no problem running functionality or security tests on 
"userdebug" (near identical to "user" builds that go to the planet) that 
is in effect rooted (su root <command>) and may have a limited few extra 
test or engineering excecutables, with a policy to upload them to 
/data/nativetest/ otherwise. Our standard POSIX tools are delivered from 
toybox, so keep that in mind.

I had looked at https://github.com/SELinuxProject/selinux-testsuite, but 
it could not easily be Android'ified because of reliance for on-target 
for Bash, Perl and Python. But I am sure there are many tests scenarios 
there that could be 'translated'.

An Android'ified test that would test sepolicy would probably leverage 
our existing policy 
(https://android.git.corp.google.com/platform/system/sepolicy/+/HEAD/ 
<https://www.google.com/url?q=https://www.google.com/url?q%3Dhttps://android.git.corp.google.com/platform/system/core/%252B/HEAD/fs_mgr/README.overlayfs.md%2523%26sa%3DD%26ust%3D1564076098999000%26usg%3DAFQjCNGi5PJ_zn-Jm_Qykb3PfLbNfEgZwA&source=gmail&ust=1564158899354000&usg=AFQjCNHVYoSdS1JcqtSpiVENiNKx-w_2cQ>) 
and free rein in /data/local/tmp/ to play mounting games.

Sincerely -- Mark Salyzyn



--------------55597218440AFED5280F150F
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">On 7/25/19 9:12 AM, Amir Goldstein
      wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:CAOQ4uxhLQGpG0=K46hAgPFgQ3KrDipUCqNs_=L6xNwG-dS_jtw@mail.gmail.com">
      <pre class="moz-quote-pre" wrap="">[reduce CC list]

</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">
</pre>
        <blockquote type="cite">
          <pre class="moz-quote-pre" wrap="">
I am fine with this patch, but would like to request that you add @sb arg
to the ovl_revert_creds() helper, so it is more useful for other things in the
future that scope the underlying layers access (like shutdown).
</pre>
        </blockquote>
        <pre class="moz-quote-pre" wrap="">
Will respin and retest.

</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
Apropos testing, I wanted to bring up this issue.
I noticed that the test coverage I have for unprivileged user access to
overlayfs is lacking.

xfstests has several generic tests that use _runas and run on overlayfs,
but that's only for pure upper files.

unionmount-testsuite is always run as root, because it needs to
mount/umount/etc.
I am working on a new mode ./run --ov --runas=1
to seteuid(1);setegid(1) before every test (after set_up and mount)
That's fine for basic UNIX permission and capability checks, but does not cover
more complex setups like with sepolicy.

I was thinking maybe to execute "./run --ov --set-up" with mounter process
credentials (e.g. initd) and then add a new mode "./run --ov --no-set-up"
which uses the mount prepared by the mounter and runs the tests.

I wanted to get feedback on the ideas above if they are useful for
your use cases? Is that enough or is there more functionality required
to cover more use cases?

Thanks,
Amir.
</pre>
    </blockquote>
    <p>I had already filed an internal bug to find a solution for this
      because I did not have a full answer to this vacuum in testing.
      Everything I do is cumbersome, manual or instrumented w.r.t.
      overlayfs with a poor velocity because solution is checked on all
      android kernel releases; and relies on a functional device (can be
      run under emulator) to smoke test the integrated result (where we
      do have some automation).</p>
    <p>These new problems that added extra patches to this series were
      only uncovered over the last two months of investigation and root
      cause on 4.14 and (very recently) 4.19 devices and have not
      discovered any automation (well, two simple tests is not enough)
      that pleases me.<br>
    </p>
    <p>We have no problem running functionality or security tests on
      "userdebug" (near identical to "user" builds that go to the
      planet) that is in effect rooted (su root &lt;command&gt;) and may
      have a limited few extra test or engineering excecutables, with a
      policy to upload them to /data/nativetest/ otherwise. Our standard
      POSIX tools are delivered from toybox, so keep that in mind.<br>
    </p>
    <p>I had looked at
      <a class="moz-txt-link-freetext" href="https://github.com/SELinuxProject/selinux-testsuite">https://github.com/SELinuxProject/selinux-testsuite</a>, but it could
      not easily be Android'ified because of reliance for on-target for
      Bash, Perl and Python. But I am sure there are many tests
      scenarios there that could be 'translated'.</p>
    <p>An Android'ified test that would test sepolicy would probably
      leverage our existing policy (<a
title="https://www.google.com/url?q=https://android.git.corp.google.com/platform/system/core/%2B/HEAD/fs_mgr/README.overlayfs.md%23&amp;sa=D&amp;ust=1564076098999000&amp;usg=AFQjCNGi5PJ_zn-Jm_Qykb3PfLbNfEgZwA"
        rel="noreferrer noopener"
data-saferedirecturl="https://www.google.com/url?q=https://www.google.com/url?q%3Dhttps://android.git.corp.google.com/platform/system/core/%252B/HEAD/fs_mgr/README.overlayfs.md%2523%26sa%3DD%26ust%3D1564076098999000%26usg%3DAFQjCNGi5PJ_zn-Jm_Qykb3PfLbNfEgZwA&amp;source=gmail&amp;ust=1564158899354000&amp;usg=AFQjCNHVYoSdS1JcqtSpiVENiNKx-w_2cQ"
        target="_blank"
href="https://www.google.com/url?q=https://www.google.com/url?q%3Dhttps://android.git.corp.google.com/platform/system/core/%252B/HEAD/fs_mgr/README.overlayfs.md%2523%26sa%3DD%26ust%3D1564076098999000%26usg%3DAFQjCNGi5PJ_zn-Jm_Qykb3PfLbNfEgZwA&amp;source=gmail&amp;ust=1564158899354000&amp;usg=AFQjCNHVYoSdS1JcqtSpiVENiNKx-w_2cQ"
        style="color: rgb(66, 133, 244); font-family: Roboto,
        sans-serif; font-size: 14px; font-style: normal;
        font-variant-ligatures: normal; font-variant-caps: normal;
        font-weight: 400; letter-spacing: 0.2px; orphans: 2; text-align:
        left; text-indent: 0px; text-transform: none; white-space:
        normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width:
        0px; background-color: rgb(255, 255, 255);">https://android.git.corp.google.com/platform/system/sepolicy/+/HEAD/</a><span
        style="color: rgb(119, 119, 119); font-family: Roboto,
        sans-serif; font-size: 14px; font-style: normal;
        font-variant-ligatures: normal; font-variant-caps: normal;
        font-weight: 400; letter-spacing: 0.2px; orphans: 2; text-align:
        left; text-indent: 0px; text-transform: none; white-space:
        normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width:
        0px; background-color: rgb(255, 255, 255);
        text-decoration-style: initial; text-decoration-color: initial;
        display: inline !important; float: none;"><span>)</span></span>
      and free rein in /data/local/tmp/ to play mounting games.</p>
    <p>Sincerely -- Mark Salyzyn<br>
    </p>
    <p><br>
    </p>
  </body>
</html>

--------------55597218440AFED5280F150F--
